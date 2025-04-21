import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ook_chat/features/preminum/widgets/preminum_dialog.dart';

import '../../../model/user.dart';
import '../../auth/bloc/auth/auth_bloc.dart';
import '../../auth/bloc/auth/auth_state.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/chat/chat_event.dart';
import '../bloc/chat/chat_state.dart';

class MessageComposer extends StatelessWidget {
  final TextEditingController controller;

  MessageComposer({super.key, required this.controller});

  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    User? user;
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) user = authState.user;

    return BlocConsumer<ChatBloc, ChatState>(listener: (ctx, state) {
      if (state is AddMessageSuccess) {
        var lastMessage = state.messages.last;
        if (!lastMessage.isUser) _speak(lastMessage.text);
      }
    }, builder: (context, state) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                onPressed: () {
                  showDialog(context: context, builder: (_) => GetPlusPremiumDialog());
                },
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    minLines: 1,
                    maxLines: 5,
                    onSubmitted: (text) => onSubmitted(context, text, user?.id),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                color: Theme.of(context).primaryColor,
                onPressed: state is! AddMessageLoading && state is! AddMessageError ? () => onSubmitted(context, controller.text, user?.id) : null,
              ),
            ],
          ),
        ),
      );
    });
  }

  onSubmitted(BuildContext context, String text, String? id) {
    final message = text.trim();
    final bloc = context.read<ChatBloc>();
    if (message.isNotEmpty && bloc.state is! AddMessageLoading && bloc.state is! AddMessageError) {
      bloc.add(AddMessageEvent(context: context, message: message, userId: id ?? ''));
      controller.clear();
    }
  }

  Future _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }
}
