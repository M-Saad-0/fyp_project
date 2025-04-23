import 'dart:convert';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:backend_services_repository/src/models/item/entities/entities.dart';
import 'package:backend_services_repository/src/utils/order_and_payment.dart';
import 'package:http/http.dart' as http;

class OrderAndPaymentImp extends OrderAndPayment {
  @override
  Future<Result<String, String>> createOrder(Map<String, dynamic> orderedItem) async {
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
  Future<Result<Map<String, dynamic>, String>> getItemsUserOrdered(User user) async {
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
      final Map<String, dynamic> itemsJson = jsonDecode(response.body);
      print(itemsJson);
      return Result.success({
        'items': itemsJson['itemObjects']
           ,
        'itemDocs': itemsJson['borrowedItems']
      });
    }
  }

  @override
  Future<Result<Map<String, dynamic>, String>> getOrderRequest(
      User user) async {
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
      final Map<String, dynamic> itemsJson = jsonDecode(response.body);
      return Result.success({
        'items': itemsJson['itemObjects']
           ,
        'itemDocs': itemsJson['lentedItems']
      });
    }
  }
}
