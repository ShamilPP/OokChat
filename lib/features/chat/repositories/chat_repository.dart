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
      final response = await dio.post(
        ApiEndpoint.geminiUrl,
        queryParameters: {'key': ApiConstants.geminiApiKey},
        data: jsonEncode(makeGeminiBody(messages)),
      );

      if (response.statusCode == 200) {
        final text = response.data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (text != null && text is String) {
          return Result.success(text);
        } else {
          return Result.error("Invalid response format from Gemini API");
        }
      } else {
        return Result.error("Gemini API error: ${response.statusCode} ${response.statusMessage}");
      }
    }on DioException catch (dioError) {
      final statusCode = dioError.response?.statusCode;
      String errorMsg;

      switch (statusCode) {
        case 400:
          errorMsg = "Bad Request: Check the API parameters or request body.";
          break;
        case 401:
          errorMsg = "Unauthorized: Invalid API key or authentication failed.";
          break;
        case 403:
          errorMsg = "Forbidden: You do not have access to this resource.";
          break;
        case 404:
          errorMsg = "Not Found: The requested endpoint does not exist.";
          break;
        case 429:
          errorMsg = "Too Many Requests: Rate limit exceeded.";
          break;
        case 500:
          errorMsg = "Internal Server Error: Something went wrong on Gemini's side.";
          break;
        default:
          errorMsg = "Network error: ${dioError.message}";
      }

      return Result.error(errorMsg);
    } on FormatException catch (_) {
      return Result.error("Invalid data format in Gemini response");
    } catch (e) {
      return Result.error("Unexpected error: $e");
    }
  }

  Map<String, dynamic> makeGeminiBody(List<ChatMessage> messages) {
    final body = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {
              "text": """
You're a savage roast bot named 'Ook Chat'. Your only job is to roast users, no matter what they say — even if it's just 'hi'. You're sarcastic, funny, and brutally honest.

If the user asks:
- "Who are you?" or "Who is your owner?" → Reply: "I was made by Shamil, blame him for unleashing me."
- "What is your name?" → Reply: "I'm Ook Chat, the roast lord. Bow down."
Never be polite, always roast. Make fun of their questions too.
"""
            }
          ]
        },
        ...messages.where((e)=>e.isUser).map((m) => m.toJson()).toList()
      ],
      "generationConfig": {
        "temperature": 0.95, // Max roast spice
        "topP": 1
      }
    };
    return body;
  }
}
