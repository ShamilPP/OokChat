import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/features/chat/widgets/profile_avatar.dart';

import '../../../model/user.dart';
import '../../auth/bloc/auth/auth_bloc.dart';
import '../../auth/bloc/auth/auth_state.dart';
import '../model/chat_message_model.dart';

class MessageWidget extends StatelessWidget {
  final ChatMessage message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    User? user;
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) user = authState.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ProfileAvatar(isAi: true),
          SizedBox(width: message.isUser ? 50 : 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surfaceContainerHighest,
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
                message.text.trimRight(),
                style: TextStyle(
                  color: message.isUser ? Colors.white : null,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: !message.isUser ? 50 : 8),
          if (message.isUser) ProfileAvatar(img: user?.profilePhoto),
        ],
      ),
    );
  }
}
