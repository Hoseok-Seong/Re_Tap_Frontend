class GoalFeedbackResp {
  final int goalId;
  final int score;
  final String feedback;

  GoalFeedbackResp({
    required this.goalId,
    required this.score,
    required this.feedback,
  });

  factory GoalFeedbackResp.fromJson(Map<String, dynamic> json) {
    return GoalFeedbackResp(
      goalId: json['goalId'],
      score: json['score'],
      feedback: json['feedback'],
    );
  }
}