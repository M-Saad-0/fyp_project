import 'dart:convert';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:backend_services_repository/src/models/item/entities/entities.dart';
import 'package:backend_services_repository/src/utils/order_and_payment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class OrderAndPaymentImp extends OrderAndPayment {
  @override
  Future<Result<String, String>> createOrder(
      Map<String, dynamic> orderedItem) async {
    final response = await http.post(Uri.parse('$api/borrowed-items'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(orderedItem));

    if (response.statusCode == 201) {
      return Result.success("Order created successfully");
    } else {
      return Result.failure("Failed to create order");
    }
  }

  @override
  Future<Result<String, String>> paymentOperation(
      String selectedPaymentOption) async {
    try {
      final response = await http.post(
        Uri.parse('$api/payment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'paymentOption': selectedPaymentOption,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          return Result.success("Payment successful");
        } else {
          return Result.failure("Payment failed: ${responseBody['message']}");
        }
      } else {
        return Result.failure(
            "Payment request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      return Result.failure("Payment operation error: $e");
    }
  }

  @override
  Future<Result<String, String>> getItemsUserOrdered(User user) async {
    //borrower
    final response = await http.get(
      Uri.parse(
        "$api/borrowed-items/user/borrowed/${user.userId}",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      return Result.failure("Error loading you items");
    } else {
      debugPrint(response.body);
      return Result.success(response.body);
    }
  }

  @override
  Future<Result<String, String>> getOrderRequest(User user) async {
    //lenter
    final response = await http.get(
      Uri.parse(
        "$api/borrowed-items/user/lent/${user.userId}",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      return Result.failure("Error loading you items");
    } else {
      return Result.success(response.body);
    }
  }

  @override
  Future<Result<String, String>> paymentGateway(
      User user, Item item, String paymentOption) async {
    final response = await http.post(
      Uri.parse('$api/payment-gateway'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'borrowerId': user.userId,
        'lenterId': item.userId,
        'itemId': item.itemId,
        'price': item.price,
        'paymentOption': paymentOption,
      }),
    );

    if (response.statusCode == 201) {
      return Result.success(jsonDecode(response.body)['paymentUrl']);
    } else {
      return Result.failure("Payment failed");
    }
  }

  @override
  Future<Result<bool, String>> payForTheRequest() {
    // TODO: implement payForTheRequest
    throw UnimplementedError();
  }

  @override
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
}
