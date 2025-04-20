import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/features/chat/repositories/chat_repository.dart';
import '../model/chat_message_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<ChatMessage> _messages = [];

  ChatRepository repository;

  ChatBloc({required this.repository}) : super(ChatInitial()) {
    on<AddMessageEvent>(_onAddMessage);
    on<RetryMessageEvent>(_onRetry);
    on<NewChatEvent>(_onNewChat);
  }

  void _onAddMessage(AddMessageEvent event, Emitter<ChatState> emit) async {
    try {
      // Add user message
      _messages.add(ChatMessage(
        text: event.message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      emit(AddMessageSuccess(List.from(_messages)));
      emit(AddMessageLoading());
      // Simulate AI thinking
      final result = await repository.geminiResponse(_messages);
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

  void _onRetry(RetryMessageEvent event, Emitter<ChatState> emit) async {
    try {
      emit(AddMessageLoading());
      // Simulate AI thinking
      final result = await repository.geminiResponse(_messages);
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
    emit(ChatInitial());
  }
}
