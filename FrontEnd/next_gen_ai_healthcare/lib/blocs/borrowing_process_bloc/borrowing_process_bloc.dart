import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_order_page.dart';

part 'borrowing_process_event.dart';
part 'borrowing_process_state.dart';

class BorrowingProcessBloc
    extends Bloc<BorrowingProcessEvent, BorrowingProcessState> {
  final OrderAndPaymentImp orderAndPaymentImp;
  BorrowingProcessBloc({required this.orderAndPaymentImp})
      : super(BorrowingProcessInitial()) {
    on<BorrowingProcessActionEvent>((event, emit) async {
      try {
        emit(BorrowingProcessLoadingState());
        debugPrint("Loading Request Status");
        Map<String, dynamic> itemBorrowed = event.itemBorrowed;
        itemBorrowed['requestStatus'] = event.newRequestStatus;
        Result<bool, String> result =
            await orderAndPaymentImp.updateBorrowedItem(itemBorrowed);
        if (result.isFailure) {
          emit(BorrowingProcessErrorState(error: result.error ?? ""));
        debugPrint("Error Request Status");

        } else {
          emit(BorrowingProcessSuccessState(borrowedItem: itemBorrowed));
        debugPrint("Success Request Status");

        }
      } catch (e) {
        emit(BorrowingProcessErrorState(error: e.toString()));
        debugPrint("Error Request Status");

      }
    });

    on<BorrowingProcessReviewdEvent>((event, emit)async{
      Map<String, dynamic> itemBorrowed = event.itemBorrowed;
        itemBorrowed['requestStatus'] = RequestStatuses.Reviewed.name;
      Result<bool, String> result =
            await orderAndPaymentImp.updateBorrowedItem(event.itemBorrowed);
    });
    
  }
}


// after the owner accepts order request only then can the payment can be made if there is any