import 'package:flutter/cupertino.dart';

abstract class ChatEvent {}

class AddMessageEvent extends ChatEvent {
  final BuildContext context;
  final String userId;
  final String message;

  AddMessageEvent({required this.context, required this.message, required this.userId});
}

class RetryMessageEvent extends ChatEvent {}

class NewChatEvent extends ChatEvent {}

class LoadChatMessagesEvent extends ChatEvent {
  final String userId;
  final String selectedChatId;

  LoadChatMessagesEvent({required this.userId, required this.selectedChatId});
}
