import '../../model/chat_message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class AddMessageLoading extends ChatState {}

class AddMessageSuccess extends ChatState {
  final List<ChatMessage> messages;

  AddMessageSuccess(this.messages);
}


class LoadMessageSuccess extends ChatState {
  final List<ChatMessage> messages;

  LoadMessageSuccess(this.messages);
}

class AddMessageError extends ChatState {
  final String error;

  AddMessageError(this.error);
}

class ChatError extends ChatState {
  final String error;

  ChatError(this.error);
}
