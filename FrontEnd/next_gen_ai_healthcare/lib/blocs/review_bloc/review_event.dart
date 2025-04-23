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
