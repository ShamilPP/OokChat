import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/features/chat/bloc/chat_list/chat_list_bloc.dart';
import 'package:ook_chat/features/chat/bloc/chat_list/chat_list_event.dart';
import 'package:ook_chat/features/chat/repositories/firebase_chat_repository.dart';

import '../../model/chat_message_model.dart';
import '../../model/chat_model.dart';
import '../../repositories/gemini_chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  String? selectedChatId;
  final List<ChatMessage> _messages = [];

  GeminiChatRepository geminiRepository;
  FirebaseChatRepository firebaseRepository;

  ChatBloc({required this.geminiRepository, required this.firebaseRepository}) : super(ChatInitial()) {
    on<AddMessageEvent>(_onAddMessage);
    on<RetryMessageEvent>(_onRetry);
    on<NewChatEvent>(_onNewChat);
    on<LoadChatMessagesEvent>(_onLoadChatMessages);
  }

  void _onAddMessage(AddMessageEvent event, Emitter<ChatState> emit) async {
    try {
      final ChatMessage userMessage = ChatMessage(text: event.message, isUser: true, timestamp: DateTime.now());
      _messages.add(userMessage);
      emit(AddMessageSuccess(List.from(_messages)));
      emit(AddMessageLoading());
      // If first message create chat and set selectedChatId
      if (_messages.length == 1) {
        final resultRoastTitle = await geminiRepository.generateRoastTitle(userMessage);
        if (resultRoastTitle.isSuccess) {
          final chat = await firebaseRepository.createChat(event.userId, Chat(title: resultRoastTitle.data ?? '', timestamp: DateTime.now()));
          selectedChatId = chat.id;
          event.context.read<ChatListBloc>().add(LoadChatList(userId: event.userId));
        }
      }

      // Add user message
      addMessageToFirebase(message: userMessage, userId: event.userId);
      // Simulate AI thinking
      final result = await geminiRepository.geminiResponse(_messages);
      if (result.isSuccess) {
        // Add AI response
        final ChatMessage aiReplyMessage = ChatMessage(text: result.data ?? '', isUser: false, timestamp: DateTime.now());
        _messages.add(aiReplyMessage);
        emit(AddMessageSuccess(List.from(_messages)));
        addMessageToFirebase(message: aiReplyMessage, userId: event.userId);
        emit(AddMessageSuccess(List.from(_messages)));
      } else {
        emit(AddMessageError(result.message!));
      }
    } catch (e) {
      emit(AddMessageError("Failed to add message: $e"));
    }
  }

  void _onRetry(RetryMessageEvent event, Emitter<ChatState> emit) async {
    try {
      emit(AddMessageLoading());
      // Simulate AI thinking
      final result = await geminiRepository.geminiResponse(_messages);
      if (result.isSuccess) {
        // Add AI response
        _messages.add(ChatMessage(
          text: result.data ?? '',
          isUser: false,
          timestamp: DateTime.now(),
        ));

        emit(AddMessageSuccess(List.from(_messages)));
      } else {
        emit(AddMessageError(result.message!));
      }
    } catch (e) {
      emit(AddMessageError("Failed to add message: $e"));
    }
  }

  void _onNewChat(NewChatEvent event, Emitter<ChatState> emit) async {
    _messages.clear();
    selectedChatId = null;
    emit(ChatInitial());
  }

  void _onLoadChatMessages(LoadChatMessagesEvent event, Emitter<ChatState> emit) async {
    try {
      _messages.clear();
      selectedChatId = event.selectedChatId;
      emit(AddMessageLoading());
      final messages = await firebaseRepository.getMessages(userId: event.userId, chatId: selectedChatId!);
      _messages.addAll(messages);
      emit(LoadMessageSuccess(List.from(_messages)));
    } catch (e) {
      emit(AddMessageError("Failed to load message: $e"));
    }
  }

  addMessageToFirebase({required ChatMessage message, required String userId}) {
    firebaseRepository.sendMessage(userId: userId, chatId: selectedChatId!, message: message);
  }
}
