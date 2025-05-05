class GoalCreateResp {
  final int goalId;

  GoalCreateResp({
    required this.goalId,
  });

  factory GoalCreateResp.fromJson(Map<String, dynamic> json) {
    return GoalCreateResp(
      goalId: json['goalId'],
    );
  }
}