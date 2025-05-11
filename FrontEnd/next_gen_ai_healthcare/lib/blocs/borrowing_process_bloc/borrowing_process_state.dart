part of 'borrowing_process_bloc.dart';

sealed class BorrowingProcessState extends Equatable {
  const BorrowingProcessState();

  @override
  List<Object> get props => [];
}

final class BorrowingProcessInitial extends BorrowingProcessState {}

final class BorrowingProcessSuccessState extends BorrowingProcessState {
  final Map<String, dynamic> borrowedItem;

  const BorrowingProcessSuccessState({required this.borrowedItem});
  @override
  List<Object> get props => [borrowedItem];
}

final class BorrowingProcessLoadingState extends BorrowingProcessState {}

final class BorrowingProcessErrorState extends BorrowingProcessState {
  final String error;

  const BorrowingProcessErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

final class BorrowingProcessAcceptSuccessState extends BorrowingProcessState {}

final class BorrowingProcessAcceptFailState extends BorrowingProcessState {}

final class BorrowingProcessRejectSuccessState extends BorrowingProcessState {}

final class BorrowingProcessRejectFailState extends BorrowingProcessState {}

final class BorrowingProcessCompleteSuccessState
    extends BorrowingProcessState {}

final class BorrowingProcessCompleteFailState extends BorrowingProcessState {}

final class BorrowingProcessReturnSuccessState extends BorrowingProcessState {}

final class BorrowingProcessReturnFailState extends BorrowingProcessState {}

final class BorrowingProcessConfirmReturnSuccessState
    extends BorrowingProcessState {}

final class BorrowingProcessConfirmReturnFailState
    extends BorrowingProcessState {}
