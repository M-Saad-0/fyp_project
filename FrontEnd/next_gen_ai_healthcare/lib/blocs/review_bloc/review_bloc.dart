import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final RetrieveData retrieveData;
  ReviewBloc({required this.retrieveData}) : super(ReviewInitial()) {
    on<FetchReviewEvent>((event, emit) async {
      emit(ReviewLoading());
      final itemId = event.itemId;
      try {
        final Result<List<Map<String, dynamic>>, String> itemReview =
            await retrieveData.getItemReviews(itemId: itemId);
        if (itemReview.isSuccess) {
          final reviews = itemReview.value;
          if (reviews == null) {
            emit(const ReviewSuccess(reviewModel: []));
            return;
          }
          final List<ReviewModel> reviewList = reviews.map((review) {
            return ReviewModel(
                itemId: itemId,
                renterName: review['renterName'],
                review: review['review'],
                personRating: review['personRating']);
          }).toList();
          emit(ReviewSuccess(reviewModel: reviewList));
        }
      } catch (e) {
        emit(ReviewError(error: e.toString()));
      }
    });
  }
}
