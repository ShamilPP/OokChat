import '../model/feedback.dart';

abstract class FeedbackEvent {}

class SubmitFeedback extends FeedbackEvent {
  final FeedbackModel feedback;

  SubmitFeedback({
    required this.feedback,
  });
}
