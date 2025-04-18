import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/features/chat/widgets/message_widget.dart';
import 'package:ook_chat/features/chat/widgets/typing_indicator.dart';
import 'package:ook_chat/features/chat/widgets/welcome_message.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../model/chat_message_model.dart';
import '../widgets/message_composer_widget.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  List<ChatMessage> messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            // onPressed: () => context.read<ChatBloc>().add(ClearChatEvent()),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is AddMessageSuccess) {
            messages = state.messages;
          }
          if (state is AddMessageSuccess || state is AddMessageLoading) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          final isLoading = state is AddMessageLoading;

          return Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? WelcomeMessage()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: isLoading ? messages.length + 1 : messages.length,
                        itemBuilder: (context, index) {
                          if (isLoading && index == messages.length) {
                            return TypingIndicator();
                          } else {
                            return MessageWidget(message: messages[index]);
                          }
                        },
                      ),
              ),
              MessageComposer(),
            ],
          );
        },
      ),
    );
  }

  _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
