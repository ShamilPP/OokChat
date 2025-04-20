import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ook_chat/features/chat/widgets/profile_avatar.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController with infinite loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // This will make the animation repeat forever
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          ProfileAvatar(isUser: false),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildDot(context, 0),
                _buildDot(context, 1),
                _buildDot(context, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(BuildContext context, int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = _controller.value;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          height: 8.0 + 4.0 * (sin((value * 3.14 * 2) + index * 1.0) + 1) / 2,
          width: 8.0 + 4.0 * (sin((value * 3.14 * 2) + index * 1.0) + 1) / 2,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(
                  0.5 + 0.5 * (sin((value * 3.14 * 2) + index * 1.0) + 1) / 2,
                ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
