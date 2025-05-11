import 'package:backend_services_repository/backend_service_repositoy.dart';

abstract class StoreData {
  Future<Result<String, String>> storeAnItem({required Item item});
  Future<Result<List<String>, String>> uploadToCloudinary(List<String> images, String id);
  Future<List<String>> getImagesFromPhone();
  Future<Result<String, String>> createItemObjectInDatabase(String userId, Item item);
}
