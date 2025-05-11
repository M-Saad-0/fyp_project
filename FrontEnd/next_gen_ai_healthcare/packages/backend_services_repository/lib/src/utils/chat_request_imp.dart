import 'dart:convert';


import 'package:backend_services_repository/src/data/api_keys.dart';
import 'package:backend_services_repository/src/models/ai_request_model.dart';
import 'package:backend_services_repository/src/utils/chat_request.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatRequestImp extends ChatRequest {
  @override
  Stream<String> postAiResponse(AiRequestModel model) async* {
  debugPrint("requesting");

  final Uri uri = Uri.parse('$chatApiUrl?query=${Uri.encodeComponent(model.query)}');

  final request = http.Request("GET", uri)
    ..headers["Content-Type"] = "application/json";

  try {
    final streamData = await http.Client().send(request);

    if (streamData.statusCode == 200) {
      yield* streamData.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((e) {
        try {
          Map<String, dynamic> jsonStream = e as Map<String, dynamic>;
          final text = jsonStream['result'] as String?;
          return text ?? "";
        } catch (e) {
          return "Error parsing response: $e";
        }
      });
    } else {
      throw Exception("Failed to fetch data: ${streamData.statusCode}");
    }
  } catch (e) {
    yield "Error: $e";
  }
}

}
