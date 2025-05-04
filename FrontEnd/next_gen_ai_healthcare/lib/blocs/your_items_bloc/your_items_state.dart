part of 'your_items_bloc.dart';

sealed class YourItemsState extends Equatable {
  const YourItemsState();
  
  @override
  List<Object> get props => [];
}

final class YourItemsInitial extends YourItemsState {}
final class YourItemsSuccessState extends YourItemsState {
  final List<Item> items;
  const YourItemsSuccessState({required this.items});
  @override 
  List<Object> get props => [items];
}
final class YourItemsLoadingState extends YourItemsState {}

final class YourItemsErrorState extends YourItemsState {
  final String errorMessage;
  const YourItemsErrorState({required this.errorMessage});
  @override 
  List<Object> get props => [errorMessage];
}
final class YourItemsDeleteState extends YourItemsState {
  final String itemId;
  const YourItemsDeleteState({required this.itemId});
  @override 
  List<Object> get props => [itemId];
}
final class YourItemsUpdateState extends YourItemsState {
  final String itemId;
  final Item item;
  const YourItemsUpdateState({required this.itemId, required this.item});
  @override 
  List<Object> get props => [itemId, item];
}
