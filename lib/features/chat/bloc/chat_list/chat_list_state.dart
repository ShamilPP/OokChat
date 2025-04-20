import '../../model/chat_model.dart';

abstract class ChatListState {}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<Chat> chats;

  ChatListLoaded(this.chats);
}

class ChatListError extends ChatListState {
  final String message;

  ChatListError(this.message);
}
