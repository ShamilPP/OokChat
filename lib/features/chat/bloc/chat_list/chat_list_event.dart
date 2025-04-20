abstract class ChatListEvent {}

class LoadChatList extends ChatListEvent {
  final String userId;

  LoadChatList({required this.userId});
}
