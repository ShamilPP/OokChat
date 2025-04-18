import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';

class MessageComposer extends StatelessWidget {
  MessageComposer({super.key});

  final TextEditingController _messageController = TextEditingController();

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
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: TextField(
                  controller: _messageController,
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
            IconButton(
              icon: const Icon(Icons.send),
              color: Theme.of(context).primaryColor,
              onPressed: () => onSubmitted(context, _messageController.text),
            ),
          ],
        ),
      ),
    );
  }

  onSubmitted(BuildContext context, text) {
    final message = text.trim();
    if (message.isNotEmpty) {
      context.read<ChatBloc>().add(AddMessageEvent(message));
      _messageController.clear();
    }
  }
}
