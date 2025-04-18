import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ook_chat/constants/api_constants.dart';
import 'package:ook_chat/features/chat/model/chat_message_model.dart';

import '../../../constants/api_endpoints.dart';
import '../../../model/network/result.dart';

class ChatRepository {
  final dio = Dio();

  Future<Result<String>> geminiResponse(List<ChatMessage> messages) async {
    try {
      final response = await dio.post(ApiEndpoint.geminiUrl, queryParameters: {'key': ApiConstants.geminiApiKey}, data: jsonEncode(makeGeminiBody(messages)));

      if (response.statusCode == 200) {
        print(response);
        return Result.success(response.data['candidates'][0]['content']['parts'][0]['text']);
      } else {
        throw Exception("Failed to fetch orders");
      }
    } catch (e) {
      throw Exception("Error fetching orders: $e");
    }
  }

  Map<String, dynamic> makeGeminiBody(List<ChatMessage> messages) {
    final body = {
      "contents": messages.map((message) => message.toJson()).toList(),
      // "generationConfig": {
      //   "temperature": 0.7, // Allows natural responses
      //   "topP": 1
      // }
    };
    return body;
  }
}
