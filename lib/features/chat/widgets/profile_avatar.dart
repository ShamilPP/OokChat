import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final bool isUser;
  const ProfileAvatar({super.key,required this.isUser});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: isUser ? Colors.green[100] : Colors.blue[100],
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy_rounded,
        color: isUser ? Colors.green[700] : Colors.blue[700],
        size: 20,
      ),
    );
  }
}
