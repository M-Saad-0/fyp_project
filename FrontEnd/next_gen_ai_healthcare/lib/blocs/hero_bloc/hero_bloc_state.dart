part of './hero_bloc_bloc.dart';



sealed class HeroBlocState extends Equatable {
  const HeroBlocState();
  
  @override
  List<Object> get props => [];
}

final class HeroInitial extends HeroBlocState {}
final class HeroLoadingState extends HeroBlocState {}
final class HeroSuccessState extends HeroBlocState {
  final List<Item> items;
  const HeroSuccessState({required this.items});
    @override
  List<Object> get props => [items];
}
final class HeroErrorState extends HeroBlocState {
  final String error;
  const HeroErrorState({required this.error});
  @override 
  List<Object> get props => [error];
}

