abstract class ChatEvent {}

class AddMessageEvent extends ChatEvent {
  final String message;

  AddMessageEvent(this.message);
}

class RetryMessageEvent extends ChatEvent {}

class NewChatEvent extends ChatEvent {}
