import 'dart:convert';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WishlistOps {
  Future<Result<bool, String>> addToWishList(
      {required String userId, required String itemId}) async {
    try {
      final response = await http.post(Uri.parse("$api/wishlist/"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'userId': userId, 'item': itemId}));

      if (response.statusCode == 201) {
        return Result.success(true);
      } else if (response.statusCode == 400) {
        return Result.failure("Bad request. Please check the data sent.");
      } else if (response.statusCode == 500) {
        return Result.failure("Server error. Please try again later.");
      } else {
        return Result.failure(
            "Failed to add item to wishlist. Unexpected error occurred.");
      }
    } catch (e) {
      return Result.failure("An error occurred: ${e.toString()}");
    }
  }

  Future<Result<List<Item>, String>> getWishlist(String userId) async {
    try {
      // print(userId);
      final response = await http.get(Uri.parse("$api/wishlist/$userId"),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final itemEntities = (responseBody['items'] as List).map((e) {
          return ItemEntity.fromJson(e as Map<String, dynamic>);
        }).toList();
        final items = itemEntities.map((e) => Item.fromEntity(e)).toList();
        return Result.success(items);
      } else if (response.statusCode >= 400 && response.statusCode <= 404) {
        return Result.failure("Wishlist not found for the given user.");
      } else if (response.statusCode == 403) {
        return Result.failure(
            "Access denied. You do not have permission to view this wishlist.");
      } else {
        return Result.failure(
            "Failed to fetch wishlist items. Unexpected error occurred. ${response.statusCode}");
      }
    } catch (e) {
      return Result.failure("An error occurred: ${e.toString()}");
    }
  }

  Future<Result<String, String>> deleteTheEntry(
      {required String userId, required String itemId}) async {
    try {
      final response =
          await http.delete(Uri.parse("$api/wishlist/$userId/$itemId"));
      if (response.statusCode == 200) {
        return Result.success(jsonDecode(response.body)['message']);
      } else if (response.statusCode == 404) {
        return Result.failure("The item does not exist");
      } else if (response.statusCode == 403) {
        return Result.failure("You do not have access for this");
      } else {
        return Result.failure(
            "Failed to delete the item from wishlist. Unexpected error.");
      }
    } catch (e) {
      return Result.failure("An error occurred: ${e.toString()}");
    }
  }

  Future<Result<bool, String>> getCurrentState(
      {required String userId, required String itemId}) async {
    try {
      final response =
          await http.get(Uri.parse("$api/wishlist/$userId/$itemId"));
      print(response.body);
      if (response.statusCode == 200) {
        return Result.success(jsonDecode(response.body)['isWishlisted']);
      } else if (response.statusCode == 404) {
        return Result.failure("The item does not exist");
      } else if (response.statusCode == 403) {
        return Result.failure("You do not have access for this");
      } else {
        return Result.failure("Unexpected error.");
      }
    } catch (e) {
      debugPrint("Error occurred: ${e.toString()}");
      return Result.failure("An error occurred: ${e.toString()}");
    }
  }
}
