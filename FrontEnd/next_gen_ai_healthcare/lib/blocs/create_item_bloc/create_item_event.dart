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
class CreateItemLoadImagesEvent extends CreateItemEvent{}