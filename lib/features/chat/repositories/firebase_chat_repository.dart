import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ook_chat/constants/key/firebase_constants.dart';

import '../model/chat_message_model.dart';
import '../model/chat_model.dart';

class FirebaseChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Chat>> getChats(String userId) async {
    try {
      final snapshot =
          await _firestore.collection(FirebaseConstants.userCollection).doc(userId).collection(FirebaseConstants.chatCollection).orderBy('timestamp', descending: true).get();
      return snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error fetching chats: $e");
      return [];
    }
  }

  Future<Chat> createChat(String userId, Chat chat) async {
    try {
      final chatRef =
          await _firestore.collection(FirebaseConstants.userCollection).doc(userId).collection(FirebaseConstants.chatCollection).add(chat.toMap()); // Assuming `chat.id` is set
      chat.id = chatRef.id;
      return chat;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatMessage>> getMessages({
    required String userId,
    required String chatId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.chatCollection)
          .doc(chatId)
          .collection(FirebaseConstants.messagesCollection)
          .orderBy('timestamp')
          .get();

      return snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc.data())).toList();
    } catch (e) {
      print("Error fetching messages: $e");
      return [];
    }
  }

  Future<void> sendMessage({
    required String userId,
    required String chatId,
    required ChatMessage message,
  }) async {
    try {
      await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.chatCollection)
          .doc(chatId)
          .collection(FirebaseConstants.messagesCollection)
          .add(message.toFirestoreJson());
    } catch (e) {
      print("Error sending message: $e");
    }
  }
}
