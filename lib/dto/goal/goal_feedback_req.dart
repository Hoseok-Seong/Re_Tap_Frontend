class GoalFeedbackReq {
  final int goalId;
  final int score;
  final String feedback;

  GoalFeedbackReq({
    required this.goalId,
    required this.score,
    required this.feedback,
  });

  Map<String, dynamic> toJson() => {
    'goalId': goalId,
    'score': score,
    'feedback': feedback,
  };
}
