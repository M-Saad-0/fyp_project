import 'dart:convert';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:backend_services_repository/src/models/user/entities/entities.dart';
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;

class ReviewOps {
  Future<Result<List<Map<String, dynamic>>, String>> getItemReviews(
      {required String itemId}) async {
    Uri uri = Uri.parse("$api/item-reviews/$itemId");
    debugPrint("Fetching reviews from $uri");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // print(response.body);
        final List<dynamic> reviewsJson = json.decode(response.body)['enrichedReviews'];
        final List<Map<String, dynamic>> jsonResponse =
            reviewsJson.map((e) => e as Map<String, dynamic>).toList();
        return Result.success(jsonResponse);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final error = json.decode(response.body)['message'] ??
            "Could not find reviews for item $itemId";
        return Result.failure(error);
      } else {
        return Result.failure("An unexpected error occurred");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return Result.failure("An error occurred: $e");
    }
  }

  Future<Result<User, String>> getUserById({required String userId}) async {
    Uri uri = Uri.parse("$api/users/$userId");
    debugPrint("Fetching user from $uri");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Result.success(
            User.fromEntity(UserEntity.fromJson(jsonResponse)));
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final error = json.decode(response.body)['message'] ??
            "Could not find user with ID $userId";
        return Result.failure(error);
      } else {
        return Result.failure("An unexpected error occurred");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return Result.failure("An error occurred: $e");
    }
  }

  Future<Result<bool, String>> updateBorrowedItem(
    Map<String, dynamic> borrowedItem) async {
  try {
    debugPrint("Sending PUT request to: $api/borrowed-items/${borrowedItem['_id']}");
    debugPrint("Request Body: ${jsonEncode(borrowedItem)}");

    final request = await http.put(
      Uri.parse("$api/borrowed-items/${borrowedItem['_id']}"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(borrowedItem),
    );

    debugPrint("Response status: ${request.statusCode}");
    debugPrint("Response body: ${request.body}");

    if (request.statusCode == 200) {
      return Result.success(true);
    } else if (request.statusCode == 500) {
      return Result.failure("We are very sorry, there was a server error!");
    } else if (request.statusCode >= 400 && request.statusCode < 500) {
    debugPrint("I think this is where it ends");

      return Result.failure("We are sorry, we could not find this item.");
    } else {
    debugPrint("I think this is where it ends");

      return Result.failure("Some unexpected error occured");
    }
  } catch (e) {
    debugPrint("Exception caught: $e");
    return Result.failure(e.toString());
  }
}

  Future<Result<bool, String>> storeAReview(
      Map<String, dynamic> itemBorrowed, String review, double rating) async {
        itemBorrowed['requestStatus'] = "Reviewed";
        updateBorrowedItem(itemBorrowed);

    final reviewModel = ReviewModel(
        itemId: itemBorrowed['itemId'],
        renterName: itemBorrowed['borrowerId'],
        review: review,
        picture: "",
        personRating: rating);
    Uri uri = Uri.parse("$api/item-reviews/");
    try {
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(reviewModel.toJson()));
      if (response.statusCode == 201) {
        return Result.success(true);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final error = json.decode(response.body)['message'] ??
            "Failed to store the review";
        return Result.failure(error);
      } else if (response.statusCode > 500) {
        return Result.failure(jsonDecode(response.body)['message']);
      } else {
        return Result.failure("We are sorry, an unexpected error occured!");
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
