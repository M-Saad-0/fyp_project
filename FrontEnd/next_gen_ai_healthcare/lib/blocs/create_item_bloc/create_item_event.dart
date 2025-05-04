part of 'create_item_bloc.dart';

sealed class CreateItemEvent extends Equatable {
  const CreateItemEvent();

  @override
  List<Object> get props => [];
}

class CreateItemRequiredEvent extends CreateItemEvent{
  final Item item;
  final List<String> imagePaths;
  final String userId;
  const CreateItemRequiredEvent({required this.item, required this.imagePaths, required this.userId});
  @override 
  List<Object> get props => [item, imagePaths, userId];
}
class CreateItemLoadImagesEvent extends CreateItemEvent{
  final List<String> previousImages;
  const CreateItemLoadImagesEvent({required this.previousImages});
  @override 
  List<Object> get props => [previousImages];
}

class CreateItemRemoveImagesEvent extends CreateItemEvent{
  final List<String> imageToRemove;
  const CreateItemRemoveImagesEvent({required this.imageToRemove});
  @override 
  List<Object> get props => [imageToRemove];
}