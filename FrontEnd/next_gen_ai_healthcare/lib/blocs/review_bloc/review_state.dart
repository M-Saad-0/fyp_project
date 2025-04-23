part of 'review_bloc.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();
  
  @override
  List<Object> get props => [];
}

final class ReviewInitial extends ReviewState {}

final class ReviewLoading extends ReviewState {}
final class ReviewSuccess extends ReviewState {
  final List<ReviewModel> reviewModel;
  const ReviewSuccess({required this.reviewModel});
  @override
  List<Object> get props => [reviewModel];
}
final class ReviewError extends ReviewState {
  final String error;
  const ReviewError({required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'ReviewError { error: $error }';
}
