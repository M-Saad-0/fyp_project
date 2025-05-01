part of 'borrowing_process_bloc.dart';

sealed class BorrowingProcessEvent extends Equatable {
  const BorrowingProcessEvent();

  @override
  List<Object> get props => [];
}

class BorrowingProcessActionEvent extends BorrowingProcessEvent{
  final Map<String, dynamic> itemBorrowed;
  final String newRequestStatus;
  const BorrowingProcessActionEvent({required this.itemBorrowed, required this.newRequestStatus});
  @override
  List<Object> get props => [itemBorrowed, newRequestStatus];
}
class BorrowingProcessRejectEvent extends BorrowingProcessEvent{
  final Map<String, dynamic> itemBorrowed;
  const BorrowingProcessRejectEvent({required this.itemBorrowed});
  @override
  List<Object> get props => [itemBorrowed];
}

class BorrowingProcessCompleteEvent extends BorrowingProcessEvent{
  final Map<String, dynamic> itemBorrowed;
  const BorrowingProcessCompleteEvent({required this.itemBorrowed});
  @override
  List<Object> get props => [itemBorrowed];
}
class BorrowingProcessReturnEvent extends BorrowingProcessEvent{
  final Map<String, dynamic> itemBorrowed;
  const BorrowingProcessReturnEvent({required this.itemBorrowed});
  @override
  List<Object> get props => [itemBorrowed];
}
class BorrowingProcessConfirmReturnEvent extends BorrowingProcessEvent{
  final Map<String, dynamic> itemBorrowed;
  const BorrowingProcessConfirmReturnEvent({required this.itemBorrowed});
  @override
  List<Object> get props => [itemBorrowed];
}


class BorrowingProcessReviewdEvent extends BorrowingProcessEvent{
   final Map<String, dynamic> itemBorrowed;
  const BorrowingProcessReviewdEvent({required this.itemBorrowed});
  @override
  List<Object> get props => [itemBorrowed];
}