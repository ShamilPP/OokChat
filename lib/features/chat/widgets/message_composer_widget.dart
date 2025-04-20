import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/features/preminum/widgets/preminum_dialog.dart';

import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class MessageComposer extends StatelessWidget {
  final TextEditingController controller;

  const MessageComposer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                  minLines: 1,
                  maxLines: 5,
                  onSubmitted: (text) => onSubmitted(context, text),
                ),
              ),
            ),
            BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.send),
                color: Theme.of(context).primaryColor,
                onPressed: state is! AddMessageLoading && state is! AddMessageError ? () => onSubmitted(context, controller.text) : null,
              );
            }),
          ],
        ),
      ),
    );
  }

  onSubmitted(BuildContext context, text) {
    final message = text.trim();
    final bloc = context.read<ChatBloc>();
    if (message.isNotEmpty && bloc.state is! AddMessageLoading && bloc.state is! AddMessageError) {
      bloc.add(AddMessageEvent(message));
      controller.clear();
    }
  }
}
