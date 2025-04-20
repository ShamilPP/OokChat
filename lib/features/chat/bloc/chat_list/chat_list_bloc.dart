import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/features/chat/repositories/firebase_chat_repository.dart';

import 'chat_list_event.dart';
import 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final FirebaseChatRepository chatRepository;

  ChatListBloc({required this.chatRepository}) : super(ChatListInitial()) {
    on<LoadChatList>((event, emit) async {
      emit(ChatListLoading());
      try {
        final chats = await chatRepository.getChats(event.userId);
        emit(ChatListLoaded(chats));
      } catch (e) {
        emit(ChatListError("Failed to load chats"));
      }
    });
  }
}
