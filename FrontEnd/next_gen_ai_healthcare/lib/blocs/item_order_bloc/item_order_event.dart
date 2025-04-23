part of 'item_order_bloc.dart';

sealed class ItemOrderEvent extends Equatable {
  const ItemOrderEvent();

  @override
  List<Object> get props => [];
}

class ItemOrderCreateEvent extends ItemOrderEvent{
  final Item item;
  final User user;
  final String paymentMethod;
  const ItemOrderCreateEvent({required this.item, required this.user, required this.paymentMethod});
  @override
  List<Object> get props => [item, user, paymentMethod];
}