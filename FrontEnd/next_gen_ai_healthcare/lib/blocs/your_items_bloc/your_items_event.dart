part of 'your_items_bloc.dart';

sealed class YourItemsEvent extends Equatable {
  const YourItemsEvent();

  @override
  List<Object> get props => [];
}


class YourItemsLoadEvent extends YourItemsEvent {
  final String userId;
  const YourItemsLoadEvent({required this.userId});
  @override
  List<Object> get props => [userId];
}

class YourItemsDeleteEvent extends YourItemsEvent {
  final String itemId;
  const YourItemsDeleteEvent({required this.itemId});
  @override
  List<Object> get props => [itemId];
}

class YourItemsUpdateEvent extends YourItemsEvent {
  final String itemId;
  final Item item;
  const YourItemsUpdateEvent({required this.itemId, required this.item});
  @override
  List<Object> get props => [itemId, item];
}

