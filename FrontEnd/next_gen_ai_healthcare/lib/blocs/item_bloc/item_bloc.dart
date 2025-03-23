import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final RetrieveDataImp retrieveData;

  ItemBloc({required this.retrieveData}) : super(ItemInitial()) {
    on<ItemRequired>((event, emit) async {
      emit(ItemLoadingState());
      try {
        Result result =
            await retrieveData.getItemsNearMe(userLocation: event.location);
        if (result.isSuccess) {
          emit(ItemSuccessState(items: result.value));
        } else {
          emit(ItemErrorState(error: result.error));
        }
      } catch (e) {
        emit(ItemErrorState(error: e.toString()));
      }
    });

    on<ItemSearchRequired>((event, emit) async {
      emit(ItemLoadingState());
      try {
        Result result = await retrieveData.searchItemsNearMe(
            userLocation: event.location, searchTerm: event.searchTerm);
        if (result.isSuccess) {
          emit(ItemSuccessState(items: result.value));
        } else {
          emit(ItemErrorState(error: result.error));
        }
      } catch (e) {
        emit(ItemErrorState(error: e.toString()));
      }
    });
  }
}
