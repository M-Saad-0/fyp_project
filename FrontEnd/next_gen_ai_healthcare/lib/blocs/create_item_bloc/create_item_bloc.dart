import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'create_item_event.dart';
part 'create_item_state.dart';

class CreateItemBloc extends Bloc<CreateItemEvent, CreateItemState> {
  final StoreDataImp storeData;
  CreateItemBloc({required this.storeData}) : super(CreateItemInitial()) {
    on<CreateItemRequiredEvent>((event, emit) async {
      emit(CreateItemLoadingState());
      try {
        Result<List<String>, String> cloudinaryResult =
            await storeData.uploadToCloudinary(event.imagePaths,
                "${DateTime.now().millisecondsSinceEpoch}${event.userId}");
        if (cloudinaryResult.isFailure) {
          emit(CreateItemErrorState(
              errorMessage: cloudinaryResult.error ?? "Error"));
          return;
        }
        Item item = event.item.copyWith(images: cloudinaryResult.value);
        Result result =
            await storeData.createItemObjectInDatabase(event.userId, item);
        if (result.isSuccess) {
          emit(CreateItemSuccessState(
              success: "${item.itemName} listed successflly!"));
        } else if (result.isFailure) {
          emit(CreateItemErrorState(errorMessage: result.error));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(const CreateItemErrorState(
            errorMessage:
                "We are very sorry. Some unexpected error occurred."));
      }
    });

    on<CreateItemLoadImagesEvent>((event, emit) async {
      List<String> imagePaths = await storeData.getImagesFromPhone();
      emit(CreateItemLoadImages(
          images: [...event.previousImages, ...imagePaths]));
    });
  }
}
