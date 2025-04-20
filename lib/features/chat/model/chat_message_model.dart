import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

// Firestore-compatible JSON
  Map<String, dynamic> toFirestoreJson() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp, // or use .millisecondsSinceEpoch
    };
  }

  // Create instance from Firestore data
  factory ChatMessage.fromFirestore(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] ?? '',
      isUser: json['isUser'] ?? false,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  //Gemini format, if you still want to keep this
  Map<String, dynamic> toGeminiJson() {
    return {
      "role": isUser ? "user" : "model",
      "parts": [
        {"text": text}
      ],
    };
  }
}
