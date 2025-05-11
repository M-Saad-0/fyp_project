part of 'item_request_order_bloc.dart';

sealed class ItemRequestOrderEvent extends Equatable {
  const ItemRequestOrderEvent();

  @override
  List<Object> get props => [];
}

class ItemOrderRequired extends ItemRequestOrderEvent{
  final User user;

  const ItemOrderRequired({required this.user});
  @override
  List<Object> get props => [user];
}
class ItemRequestRequired extends ItemRequestOrderEvent{
  final User user;

  const ItemRequestRequired({required this.user});
  @override
  List<Object> get props => [user];
}
