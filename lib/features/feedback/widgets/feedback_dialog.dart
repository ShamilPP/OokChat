import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/features/auth/bloc/auth/auth_bloc.dart';
import 'package:ook_chat/features/feedback/model/feedback.dart';

import '../../auth/bloc/auth/auth_state.dart';
import '../bloc/feedback_bloc.dart';
import '../bloc/feedback_event.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  String _feedbackType = 'General';
  bool _isSubmitting = false;

  final List<String> _feedbackTypes = [
    'General',
    'Bug Report',
    'Feature Request',
    'Performance Issue',
    'User Experience',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    var authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      FeedbackModel feedback = FeedbackModel(
        userId: authState.user.id ?? "",
        userName: authState.user.name,
        feedbackType: _feedbackType,
        feedbackText: _feedbackController.text,
        timestamp: DateTime.now(),
        rating: _rating,
      );
      context.read<FeedbackBloc>().add(SubmitFeedback(feedback: feedback));
    }
    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    // Close dialog and show success message
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your feedback!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.feedback_outlined,
                    color: theme.colorScheme.primary,
                    size: 23,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'We Value Your Feedback',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    splashRadius: 24,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'How would you rate your experience?',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: index < _rating
                            ? Colors.amber
                            : isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                        size: 36,
                      ),
                      splashRadius: 24,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Feedback type',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _feedbackType,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _feedbackTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _feedbackType = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Tell us more (optional)',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _feedbackController,
                decoration: const InputDecoration(
                  hintText: 'Please share your thoughts...',
                  contentPadding: EdgeInsets.all(16),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitFeedback,
                    child: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : const Text('Submit Feedback'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
