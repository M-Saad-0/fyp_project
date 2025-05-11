import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistOps wishlistOps;
  WishlistBloc({required this.wishlistOps}) : super(WishlistInitial()) {
    on<WishlistAddEvent>((event, emit) async {
      try {
        final Result<bool, String> result = await wishlistOps.addToWishList(
            userId: event.userId, itemId: event.itemId);
        if (result.isFailure) {
          emit(WishlistErrorState(error: result.error!));
        } else {
          return;
        }
      } catch (e) {
        emit(WishlistErrorState(error: e.toString()));
      }
    });

    on<WishlistDeleteEvent>((event, emit) async {
      try {
        // emit(WishlistLoadingState());
        Result<String, String> result = await wishlistOps.deleteTheEntry(
            userId: event.userId, itemId: event.itemId);
        if (result.isFailure) {
          // emit(WishlistDeleteErrorState(error: result.error!));
        } else {
          add(WishlistFetchEvent(userId: event.userId));
          // emit(WishlistDeleteSuccessState(message: result.value!));
        }
      } catch (e) {
        // emit(WishlistErrorState(error: e.toString()));
      }
    });

    on<WishlistFetchEvent>((event, emit) async {
      try {
        emit(WishlistLoadingState());
        Result<List<Item>, String> result =
            await wishlistOps.getWishlist(event.userId);
        if (result.isFailure) {
          emit(WishlistErrorState(error: result.error!));
        } else {
          emit(WishlistSuccessState(wishlistItems: result.value!));
        }
      } catch (e) {
        emit(WishlistErrorState(error: 'Error: ${e.toString()}'));
      }
    });

    on<WishlistGetCurrentEvent>((event, emit) async {
      try {
        Result<bool, String> currentState = await wishlistOps.getCurrentState(
            userId: event.userId, itemId: event.itemId);
        if (currentState.isFailure) {
          emit(const WishlistCurrentState(currentState: false));
        } else {
          emit(WishlistCurrentState(currentState: currentState.value!));
        }
      } catch (e) {
        print(e.toString());
        return;
      }
    });

    on<WishlistChangeCurrentEvent>((event, emit){
      emit(WishlistCurrentState(currentState: !event.currentState));
    });
  }
}
