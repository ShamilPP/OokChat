class FeedbackModel {
  final String userId;
  final String userName;
  final String feedbackType;
  final String feedbackText;
  final DateTime timestamp;
  final int rating; // Optional, in case you want to include a rating for the feedback

  // Constructor
  FeedbackModel({
    required this.userId,
    required this.userName,
    required this.feedbackType,
    required this.feedbackText,
    required this.timestamp,
    required this.rating,
  });

  // Factory method to create a FeedbackModel object from JSON
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      userId: json['userId'],
      userName: json['userName'],
      feedbackType: json['feedbackType'],
      feedbackText: json['feedbackText'],
      timestamp: DateTime.parse(json['timestamp']),
      rating: json['rating'] ?? 0, // Default to 0 if no rating provided
    );
  }

  // Method to convert a FeedbackModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'feedbackType': feedbackType,
      'feedbackText': feedbackText,
      'timestamp': timestamp,
      'rating': rating,
    };
  }
}
