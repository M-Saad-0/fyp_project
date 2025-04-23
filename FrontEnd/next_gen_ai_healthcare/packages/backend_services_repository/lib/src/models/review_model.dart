class ReviewModel {
  final String itemId;
  final String renterName;
  final String review;
  final double personRating;

  const ReviewModel(
      {required this.itemId,
      required this.renterName,
      required this.review,
      required this.personRating});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      itemId: json['itemId'] as String,
      renterName: json['renterName'] as String,
      review: json['review'] as String,
      personRating: json['personRating'] as double,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'renterName': renterName,
      'review': review,
      'personRating': personRating,
    };
  }

  ReviewModel copyWith({String? itemId, String? renterName, String? review, double? personRating}){
    return ReviewModel(
      itemId: itemId?? this.itemId,
      renterName: renterName?? this.renterName,
      review: review?? this.review,
      personRating: personRating?? this.personRating
    );
  }
}
