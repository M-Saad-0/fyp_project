part of 'item_request_order_bloc.dart';

sealed class ItemRequestOrderState extends Equatable {
  const ItemRequestOrderState();
  
  @override
  List<Object> get props => [];
}

final class ItemRequestOrderInitial extends ItemRequestOrderState {}
final class ItemRequestOrderLoading extends ItemRequestOrderState {}
final class ItemRequestOrderSuccess extends ItemRequestOrderState {
  final List<Item> items;
  final List<Map<String, dynamic>> itemDocs;
  const ItemRequestOrderSuccess({required this.itemDocs, required this.items});
  @override
  List<Object> get props => [items, itemDocs];
}

final class ItemRequestOrderError extends ItemRequestOrderState {
  final String errorMessage;
  const ItemRequestOrderError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
