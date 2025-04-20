import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? id;
  final String title;
  final DateTime timestamp;

  Chat({
    this.id,
    required this.title,
    required this.timestamp,
  });

  factory Chat.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    return Chat(
      id: data.id,
      title: data.data()['title'] ?? '',
      timestamp: (data.data()['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'timestamp': timestamp // or use .millisecondsSinceEpoch
    };
  }
}
