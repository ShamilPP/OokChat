import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/features/chat/widgets/error_message_widget.dart';
import 'package:ook_chat/features/chat/widgets/message_widget.dart';
import 'package:ook_chat/features/chat/widgets/typing_indicator.dart';
import 'package:ook_chat/features/chat/widgets/welcome_message.dart';

import '../bloc/chat/chat_bloc.dart';
import '../bloc/chat/chat_event.dart';
import '../bloc/chat/chat_state.dart';
import '../model/chat_message_model.dart';
import '../widgets/home_drawer.dart';
import '../widgets/message_composer_widget.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  List<ChatMessage> messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Ook Chat')),
      drawer: HomeDrawer(),
      body: SafeArea(
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatInitial) {
              messages = [];
            } else if (state is AddMessageSuccess) {
              messages = state.messages;
            }
            if (state is AddMessageSuccess || state is AddMessageLoading) {
              _scrollToBottom();
            }
          },
          builder: (context, state) {
            final isLoading = state is AddMessageLoading;
            final isError = state is AddMessageError;

            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? WelcomeMessage()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16.0),
                          itemCount: isLoading || isError ? messages.length + 1 : messages.length,
                          itemBuilder: (context, index) {
                            if ((isLoading || isError) && index == messages.length) {
                              if (isLoading) {
                                return TypingIndicator();
                              } else if (isError) {
                                return ErrorMessageWidget(message: state.error);
                              }
                            } else {
                              return MessageWidget(message: messages[index]);
                            }
                            return null;
                          },
                        ),
                ),
                if (state is AddMessageError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ChatBloc>().add(RetryMessageEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: theme.colorScheme.tertiary,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        side: BorderSide(color: theme.colorScheme.tertiary, width: 1),
                      ),
                      child: Text("Retry", style: TextStyle(fontSize: 18)),
                    ),
                  )
                else
                  MessageComposer(controller: _messageController),
              ],
            );
          },
        ),
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
