part of 'create_item_bloc.dart';

sealed class CreateItemState extends Equatable {
  const CreateItemState();
  
  @override
  List<Object> get props => [];
}

final class CreateItemInitial extends CreateItemState {}
final class CreateItemSuccessState extends CreateItemState {
  final String success;
  // final List<String> images;
  const CreateItemSuccessState({required this.success});
  @override 
  List<Object> get props => [success];
}
final class CreateItemLoadingState extends CreateItemState {}
final class CreateItemLoadImages extends CreateItemState {
  final List<String> images;
  const CreateItemLoadImages({required this.images});
  @override 
  List<Object> get props => [images];
}
final class CreateItemErrorState extends CreateItemState {
  final String errorMessage;
  const CreateItemErrorState({required this.errorMessage});
  @override 
  List<Object> get props => [errorMessage];
}
