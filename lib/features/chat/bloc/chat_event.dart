abstract class ChatEvent {}

class AddMessageEvent extends ChatEvent {
  final String message;

  AddMessageEvent(this.message);
}
