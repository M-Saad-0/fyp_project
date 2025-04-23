import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'item_request_order_event.dart';
part 'item_request_order_state.dart';

class ItemRequestOrderBloc
    extends Bloc<ItemRequestOrderEvent, ItemRequestOrderState> {
  final OrderAndPaymentImp orderAndPaymentImp;
  ItemRequestOrderBloc({required this.orderAndPaymentImp})
      : super(ItemRequestOrderInitial()) {
    on<ItemOrderRequired>((event, emit) async {
      Result<Map<String, dynamic>, String> items =
          await orderAndPaymentImp.getItemsUserOrdered(event.user);
      if (items.isFailure) {
        emit(ItemRequestOrderError(errorMessage: items.error!));
      } else {
        emit(ItemRequestOrderSuccess(
            items: (items.value!['items'] as List)
                .map((item) => Item.fromEntity(ItemEntity.fromJson(item)))
                .toList(),
            itemDocs: items.value!['itemDocs']));
      }
    });

    on<ItemRequestRequired>((event, emit) async {
      Result<Map<String, dynamic>, String> items =
          await orderAndPaymentImp.getOrderRequest(event.user);
      if (items.isFailure) {
        emit(ItemRequestOrderError(errorMessage: items.error!));
      } else {
        emit(ItemRequestOrderSuccess(
            items: (items.value!['items'] as List)
                .map((item) => Item.fromEntity(ItemEntity.fromJson(item)))
                .toList(),
            itemDocs: items.value!['itemDocs']));
      }
    });
  }
}
