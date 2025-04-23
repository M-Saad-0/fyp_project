import 'package:backend_services_repository/backend_service_repositoy.dart';

abstract class OrderAndPayment {
  Future<Result<String, String>> paymentOperation(String selectedPaymentOption);
  Future<Result<String, String>> createOrder(Map<String, dynamic> orderedItem);
  Future<Result<Map<String, dynamic>, String>> getItemsUserOrdered(User user);
  Future<Result<Map<String, dynamic>, String>> getOrderRequest(User user);
}