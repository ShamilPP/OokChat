import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ook_chat/constants/gemini_constants.dart';
import 'package:ook_chat/features/chat/model/chat_message_model.dart';

import '../../../constants/api_endpoints.dart';
import '../../../model/network/result.dart';

class GeminiChatRepository {
  final Dio _dio = Dio();

  Future<Result<String>> geminiResponse(List<ChatMessage> messages) async {
    try {
      final response = await _dio.post(
        ApiEndpoint.geminiUrl,
        queryParameters: {'key': GeminiConstants.geminiApiKey},
        data: jsonEncode(_buildGeminiRequestBody(messages)),
      );

      final text = response.data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (response.statusCode == 200 && text is String) {
        return Result.success(text);
      }
      return Result.error("Invalid response format from Gemini API");
    } on DioException catch (dioError) {
      return Result.error(_getDioErrorMessage(dioError));
    } on FormatException {
      return Result.error("Invalid data format in Gemini response");
    } catch (e) {
      return Result.error("Unexpected error: $e");
    }
  }

  Future<Result<String>> generateRoastTitle(ChatMessage message) async {
    try {
      final response = await _dio.post(
        ApiEndpoint.geminiUrl,
        queryParameters: {'key': GeminiConstants.geminiApiKey},
        data: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": GeminiConstants.geminiRoastInstruction(message.text)},
              ]
            },
          ],
          "generationConfig": {
            "temperature": GeminiConstants.geminiTemperature,
            "topP": GeminiConstants.geminiTopP,
            "presence_penalty": GeminiConstants.geminiPresencePenalty,
            "frequency_penalty": GeminiConstants.geminiFrequencyPenalty,
          }
        }),
      );

      final text = response.data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (response.statusCode == 200 && text is String) {
        return Result.success(text);
      }
      return Result.error("Invalid response format from Gemini API");
    } on DioException catch (dioError) {
      return Result.error(_getDioErrorMessage(dioError));
    } on FormatException {
      return Result.error("Invalid data format in Gemini response");
    } catch (e) {
      return Result.error("Unexpected error: $e");
    }
  }

  Map<String, dynamic> _buildGeminiRequestBody(List<ChatMessage> messages) {
    return {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": GeminiConstants.geminiInstruction}
          ]
        },
        ...messages.map((m) => m.toGeminiJson())
      ],
      "generationConfig": {
        "temperature": GeminiConstants.geminiTemperature,
        "topP": GeminiConstants.geminiTopP,
        "presence_penalty": GeminiConstants.geminiPresencePenalty,
        "frequency_penalty": GeminiConstants.geminiFrequencyPenalty,
      }
    };
  }

  String _getDioErrorMessage(DioException dioError) {
    final statusCode = dioError.response?.statusCode;
    return switch (statusCode) {
      400 => "Bad Request: Check the API parameters or request body.",
      401 => "Unauthorized: Invalid API key or authentication failed.",
      403 => "Forbidden: You do not have access to this resource.",
      404 => "Not Found: The requested endpoint does not exist.",
      429 => "Too Many Requests: Rate limit exceeded.",
      500 => "Internal Server Error: Something went wrong on Gemini's side.",
      _ => "Network error: ${dioError.message}",
    };
  }
}
