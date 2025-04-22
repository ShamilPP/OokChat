abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}

class FeedbackSubmitting extends FeedbackState {}

class FeedbackSubmitted extends FeedbackState {}

class FeedbackSubmissionFailed extends FeedbackState {
  final String error;
  FeedbackSubmissionFailed(this.error);
}
