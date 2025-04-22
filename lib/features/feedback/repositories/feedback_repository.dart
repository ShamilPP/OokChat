import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ook_chat/features/feedback/model/feedback.dart';

import '../../../constants/firebase_constants.dart';

class FeedbackRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Submit feedback to Firestore
  Future<void> submitFeedback(FeedbackModel feedback) async {
    try {
      await _firestore.collection(FirebaseConstants.feedbackCollection).add(feedback.toJson());
    } catch (e) {
      print("Error submitting feedback: $e");
      return null; // Return null if an error occurs during feedback submission
    }
  }
}
