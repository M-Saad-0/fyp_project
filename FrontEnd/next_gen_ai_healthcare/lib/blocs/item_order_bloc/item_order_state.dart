part of 'item_order_bloc.dart';

sealed class ItemOrderState extends Equatable {
  const ItemOrderState();
  
  @override
  List<Object> get props => [];
}

final class ItemOrderInitial extends ItemOrderState {}
final class ItemOrderLoading extends ItemOrderState {}
final class ItemOrderSuccess extends ItemOrderState {
  final String success;
  const ItemOrderSuccess({required this.success});
  @override
  List<Object> get props => [success];
}
final class ItemOrderError extends ItemOrderState {
  final String error;
  const ItemOrderError({required this .error});
  @override
  List<Object> get props => [error];
}
