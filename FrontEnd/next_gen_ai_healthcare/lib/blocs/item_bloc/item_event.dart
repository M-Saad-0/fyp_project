part of 'item_bloc.dart';

sealed class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}


class ItemRequired extends ItemEvent{
  final Map<String, dynamic> location;
  const ItemRequired({this.location=const {}});
  @override 
  List<Object> get props => [location];
}

class MoreItemsRequired extends ItemEvent{
  final int setNo;
  final Map<String, dynamic> location;
  const MoreItemsRequired({required this.setNo, required this.location});
  @override
  List<Object> get props => [setNo, location];
}

class ItemSearchRequired extends ItemEvent{
  final String searchTerm;
final Map<String, dynamic> location;
 const ItemSearchRequired({required this.searchTerm, required this.location});

  @override
  List<Object> get props => [searchTerm];
}