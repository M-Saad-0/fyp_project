import 'package:hive/hive.dart';

part 'ai_request_model.g.dart';
@HiveType(typeId: 0) // Assign a unique type ID
class AiRequestModel extends HiveObject {
  @HiveField(0)
  final String query;

  @HiveField(1)
  final String? image;

  @HiveField(2)
  final String? reponse;

  @HiveField(3)
  final String date;

  AiRequestModel({
    required this.query,
    required this.image,
    required this.date,
    this.reponse = "",
  });

  factory AiRequestModel.fromJson(Map<String, dynamic> model) {
    return AiRequestModel(
      query: model['query'],
      image: model['image'],
      date: model['date'],
      reponse: model['response'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'query': query, 'image': image, 'response': reponse, 'date': date};
  }

  AiRequestModel copyFrom({
    String? query,
    String? image,
    String? reponse,
    String? date,
  }) {
    return AiRequestModel(
      query: query ?? this.query,
      image: image ?? this.image,
      reponse: reponse ?? this.reponse,
      date: date ?? this.date,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiRequestModel && other.query == query;
  }

  @override
  int get hashCode => query.hashCode;
}
