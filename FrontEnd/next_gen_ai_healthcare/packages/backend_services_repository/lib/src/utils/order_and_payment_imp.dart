import 'dart:convert';

import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:backend_services_repository/src/item/entities/entities.dart';
import 'package:backend_services_repository/src/utils/order_and_payment.dart';
import 'package:http/http.dart' as http;

class OrderAndPaymentImp extends OrderAndPayment {
  @override
  Future<Result<String, String>> createOrder(Item orderedItem) async {
    final response = await http.post(Uri.parse('$api/borrowed-items'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(ItemEntity.toJson(Item.toEntity(orderedItem))));

    if (response.statusCode == 200) {
      return Result.success("Order created successfully");
    } else {
      return Result.failure("Failed to create order");
    }
  }

  @override
  Future<Result<String, String>> paymentOperation(
      String selectedPaymentOption) async {
    // TODO: implement paymentOperation
    return Result.failure("error");
  }

  @override
  Future<List<Item>> getItemsUserOrdered(User user) async {
    final response = await http.get(
      Uri.parse(
        "$api/borrowed-items/borrowed/${user.userId}",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      return [];
    } else {
      final List<dynamic> itemsJson = jsonDecode(response.body);
      return itemsJson
          .map((json) => Item.fromEntity(ItemEntity.fromJson(json)))
          .toList();
    }
  }

  @override
  Future<List<Item>> getOrderRequest(User user) async {
    final response = await http.get(
      Uri.parse(
        "$api/borrowed-items/lent/${user.userId}",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      return [];
    } else {
      final List<dynamic> itemsJson = jsonDecode(response.body);
      return itemsJson
          .map((json) => Item.fromEntity(ItemEntity.fromJson(json)))
          .toList();
    }
  }
}
