class GoalDeleteReq {
  final List<int> goalIds;

  GoalDeleteReq({
    required this.goalIds,
  });

  Map<String, dynamic> toJson() => {
    'goalIds': goalIds,
  };
}
