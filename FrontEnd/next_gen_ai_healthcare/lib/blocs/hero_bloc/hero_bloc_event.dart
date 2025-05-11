part of 'hero_bloc_bloc.dart';

sealed class HeroBlocEvent extends Equatable {
  const HeroBlocEvent();

  @override
  List<Object> get props => [];
}

class MoreHeroItemsRequired extends HeroBlocEvent{
  final int setNo;
  final Map<String, dynamic> location;
  const MoreHeroItemsRequired({required this.setNo, required this.location});
  @override
  List<Object> get props => [setNo, location];
}