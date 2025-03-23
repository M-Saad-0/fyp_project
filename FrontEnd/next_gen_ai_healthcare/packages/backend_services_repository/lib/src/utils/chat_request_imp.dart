import 'dart:convert';


import 'package:backend_services_repository/src/data/api_keys.dart';
import 'package:backend_services_repository/src/models/ai_request_model.dart';
import 'package:backend_services_repository/src/utils/chat_request.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatRequestImp extends ChatRequest {
  @override
  Stream<String> postAiResponse(AiRequestModel model) async* {
    debugPrint("reqquestin");
    final Uri uri = Uri.parse(chatApiUrl);
    final request =
        http.Request("POST", uri)
          ..headers["Content-Type"] = "application/json"
          ..body = json.encode({
            'contents': [
              {
                "parts": [
                  {"text": model.query},
                ],
              },
            ],
          });

    try {
      final streamData = await http.Client().send(request);

      // ✅ Ensure status is OK before processing the stream
      if (streamData.statusCode == 200) {
        // ✅ Transform stream chunks properly
        yield* streamData.stream.transform(utf8.decoder).transform(json.decoder).map((e) {
          try {
            Map<String, dynamic> jsonStream = e as Map<String, dynamic>;
            // final candidates = jsonStream['cadidates'] as List<dynamic>;
            // if (candidates != null && candidates.isNotEmpty) {

            // }
            final text =
                jsonStream['candidates']
                    .first['content']['parts']
                    .first['text'];
            return text ?? "";
          } catch (e) {
            return "Error parsing response: $e";
          }
        });
      } else {
        throw Exception("Failed to fetch data: ${streamData.statusCode}");
      }
    } catch (e) {
      yield "Error: $e"; // ✅ Proper error handling
    }
  }
}
