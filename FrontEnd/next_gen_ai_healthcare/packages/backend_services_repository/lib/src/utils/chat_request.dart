import 'package:backend_services_repository/src/models/ai_request_model.dart';

abstract class ChatRequest {
  Stream<String> postAiResponse(AiRequestModel model);
}