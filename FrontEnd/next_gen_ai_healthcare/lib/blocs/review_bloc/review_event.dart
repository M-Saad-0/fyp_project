part of 'review_bloc.dart';

sealed class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

final class FetchReviewEvent extends ReviewEvent {
  final String itemId;
  const FetchReviewEvent({required this.itemId});
  @override
  List<Object> get props => [itemId];
}

final class AddReviewEvent extends ReviewEvent {
  final Map<String, dynamic> itemBorrowed;
  final String review;
  final double rating;
  const AddReviewEvent({required this.review, required this.itemBorrowed, required this.rating});
  @override
  List<Object> get props => [itemBorrowed, review, rating];
}