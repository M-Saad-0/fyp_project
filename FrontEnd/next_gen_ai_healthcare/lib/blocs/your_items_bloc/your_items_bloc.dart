import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'your_items_event.dart';
part 'your_items_state.dart';

class YourItemsBloc extends Bloc<YourItemsEvent, YourItemsState> {
  final RetrieveDataImp itemImp;
  YourItemsBloc({required this.itemImp}) : super(YourItemsInitial()) {
    on<YourItemsLoadEvent>((event, emit) async {
      emit(YourItemsLoadingState());
      try {
        final items = await itemImp.getItemsByUser(userId: event.userId);
        if(items.isFailure){
        emit(YourItemsErrorState(errorMessage: items.error!.toString()));
        }else{
        emit(YourItemsSuccessState(items: items.value!));

        }
      } catch (e) {
        emit(YourItemsErrorState(errorMessage: e.toString()));
      }
    });

    on<YourItemsDeleteEvent>((event, emit) async {
      emit(YourItemsLoadingState());
      try {
        await itemImp.deleteItem(itemId: event.itemId);
        emit(YourItemsDeleteState(itemId: event.itemId));
      } catch (e) {
        emit(YourItemsErrorState(errorMessage: e.toString()));
      }
    });

    on<YourItemsUpdateEvent>((event, emit) async {
      emit(YourItemsLoadingState());
      try {
        await itemImp.updateItem(itemId: event.itemId, item: event.item);
        emit(YourItemsUpdateState(itemId: event.itemId, item: event.item));
      } catch (e) {
        emit(YourItemsErrorState(errorMessage: e.toString()));
      }
    });
  }
}
