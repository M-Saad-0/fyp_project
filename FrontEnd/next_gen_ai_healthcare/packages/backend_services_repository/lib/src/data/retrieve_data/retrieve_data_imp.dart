import 'dart:convert';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:backend_services_repository/src/models/item/entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RetrieveDataImp extends RetrieveData {
  @override
  Future<Result<List<Item>, String>> getItemsNearMe(
      {Map<String, dynamic> userLocation = const {}, int setNo = 1}) async {
    try {
      Uri url = Uri.parse("$api/items");
      debugPrint("Fetching items from $url");

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        debugPrint("Parsed response: $responseBody");

        List<Item> items = (responseBody as List)
            .map((e) => Item.fromEntity(ItemEntity.fromJson(e)))
            .toList();
        return Result.success(items);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final error =
            json.decode(response.body)['message'] ?? "Failed to load data";
        return Result.failure(error);
      } else {
        return Result.failure("An unexpected error has occurred");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return Result.failure("An error occurred: $e");
    }
  }

  @override
  Future<Result<List<Item>, String>> searchItemsNearMe(
      {Map<String, dynamic> userLocation = const {},
      required String searchTerm}) async {
    Uri uri = Uri.parse("$api/items/search?query=$searchTerm");
    debugPrint("Searching items from $uri");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List;
        final searchedItems = jsonResponse
            .map((e) => Item.fromEntity(ItemEntity.fromJson(e)))
            .toList();
        return Result.success(searchedItems);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final error = json.decode(response.body)['message'] ??
            "Could not find $searchTerm";
        return Result.failure(error);
      } else {
        return Result.failure("An unexpected error occurred");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return Result.failure("An error occurred: $e");
    }
  }
}
