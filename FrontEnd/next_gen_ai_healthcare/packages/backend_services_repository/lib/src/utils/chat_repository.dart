import 'package:backend_services_repository/src/models/ai_request_model.dart';
import 'package:backend_services_repository/src/models/chats.dart';

abstract class ChatRepository {
  Future<void> saveChat(List<AiRequestModel> models);

  Future<List<String>> getChatKeys();

  Future<Chats> getEntireChat(String key);

  Future<void> deleteEntireChat(String key);
}
