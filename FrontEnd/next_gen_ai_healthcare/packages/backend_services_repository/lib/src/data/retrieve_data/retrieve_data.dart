import 'package:backend_services_repository/backend_service_repositoy.dart';


abstract class RetrieveData {
  Future<Result<List<Item>, String>> getItemsNearMe({Map<String, dynamic> userLocation=const {}, int setNo=1}); //If Location is Turned off then grab random items
  Future<Result<List<Item>, String>> searchItemsNearMe({Map<String, dynamic> userLocation=const {}, required String searchTerm});
  Future<Result<List<Item>, String>> getItemsByUser({required String userId});
  Future<Result<List<Map<String, dynamic>>, String>> getItemReviews({required String itemId});
  Future<Result<User, String>> getUserById({required String userId});
  Future<Result<bool, String>> deleteItem({required String itemId});
  Future<Result<bool, String>> updateItem({required String itemId, required Item item});
  
}