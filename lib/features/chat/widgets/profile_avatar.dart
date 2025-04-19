import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final bool isUser;
  final double? height;
  final double? width;
  final double size;

  const ProfileAvatar({super.key, required this.isUser, this.height, this.width, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CircleAvatar(
        backgroundColor: isUser ? Colors.green[100] : Colors.blue[100],
        child: Icon(
          isUser ? Icons.person : Icons.smart_toy_rounded,
          color: isUser ? Colors.green[700] : Colors.blue[700],
          size: size,
        ),
      ),
    );
  }
}
