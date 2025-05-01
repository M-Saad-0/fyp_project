import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewOps reviewOps;
  ReviewBloc({required this.reviewOps}) : super(ReviewInitial()) {
    on<FetchReviewEvent>((event, emit) async {
      emit(ReviewLoading());
      final itemId = event.itemId;
      try {
        final Result<List<Map<String, dynamic>>, String> itemReview =
            await reviewOps.getItemReviews(itemId: itemId);
        if (itemReview.isSuccess) {
          final reviews = itemReview.value;
          if (reviews == null) {
            emit(const ReviewSuccess(reviewModel: []));
            return;
          }
          print(reviews);
          final List<ReviewModel> reviewList = reviews.map((review) {
            return ReviewModel(
                itemId: itemId,
                renterName: review['renterName'],
                review: review['review'],
                picture: review['renterPicture'],
                personRating: review['personRating'].toDouble());
          }).toList();
          emit(ReviewSuccess(reviewModel: reviewList));
        }
      } catch (e) {
        print(e.toString());
        emit(ReviewError(error: e.toString()));
      }
    });

    on<AddReviewEvent>((event, emit) async {
      emit(ReviewLoading());
      try {
        final Result<bool, String> result = await reviewOps.storeAReview(
            event.itemBorrowed, event.review, event.rating);
        if (result.isFailure) {
          emit(ReviewError(error: result.error!));
        } else {
          emit(ReviewUploadSuccess());
        }
      } catch (e) {
        emit(ReviewError(error: e.toString()));
      }
    });
  }
}
