class ReviewModel {
  final String itemId;
  final String renterName;
  final String review;
  final double personRating;
  final String picture;

  const ReviewModel(
      {required this.itemId,
      required this.renterName,
      required this.review,
      required this.personRating,
      required this.picture
      });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      itemId: json['itemId'] as String,
      renterName: json['renterName'] as String,
      review: json['review'] as String,
      personRating: json['personRating'] as double,
      picture: json['renterPicture']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'borrowerId': renterName,
      'review': review,
      'personRating': personRating,
    };
  }

 
}
