
import 'package:backend_services_repository/src/models/ai_request_model.dart';
import 'package:backend_services_repository/src/models/chats.dart';
import 'package:backend_services_repository/src/utils/chat_repository.dart';
import 'package:hive/hive.dart';

class ChatRepositoryImp implements ChatRepository{
  @override
  Future<void> saveChat(List<AiRequestModel> models) async {
    late Chats chats;
    final box = Hive.box<Chats>('chats');
    final Chats oldChatsOfTheDay =
        box.get(models.first.date) ?? Chats(allChatsPerDay: []);

    final updateChat = models.toSet();
    updateChat.addAll(oldChatsOfTheDay.allChatsPerDay);
    chats = Chats(allChatsPerDay: updateChat.toList());
    await box.put(models.first.date, chats);
  }

  @override
  Future<List<String>> getChatKeys() async {
    final box = Hive.box<Chats>('chats');
    final keys = box.keys.cast<String>().toList();
    return keys;
  }

  @override
  Future<Chats> getEntireChat(String key) async {
    final box = Hive.box<Chats>('chats');
    return box.get(key) ?? Chats(allChatsPerDay: []);
  }

  @override
  Future<void> deleteEntireChat(String key) async {
    final box = Hive.box<Chats>('chats');
    box.delete(key);
  }
}