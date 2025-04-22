import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/feedback_repository.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackRepository feedbackRepository;

  FeedbackBloc({required this.feedbackRepository}) : super(FeedbackInitial()) {
    on<SubmitFeedback>(_onSubmitFeedback);
  }

  Future<void> _onSubmitFeedback(
    SubmitFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackSubmitting());

    try {
      await feedbackRepository.submitFeedback(event.feedback);
      emit(FeedbackSubmitted());
    } catch (e) {
      emit(FeedbackSubmissionFailed(e.toString()));
    }
  }
}
