import 'package:flutter/material.dart';
import 'package:ook_chat/features/chat/widgets/profile_avatar.dart';

import '../model/chat_message_model.dart';

class MessageWidget extends StatelessWidget {
  final ChatMessage message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ProfileAvatar(isUser: false),
          SizedBox(width: message.isUser ? 50 : 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : null,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: !message.isUser ? 50 : 8),
          if (message.isUser) ProfileAvatar(isUser: true),
        ],
      ),
    );
  }
}
