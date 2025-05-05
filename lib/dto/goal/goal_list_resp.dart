class GoalListResp {
  final List<GoalSummary> goals;

  GoalListResp({required this.goals});

  factory GoalListResp.fromJson(Map<String, dynamic> json) {
    return GoalListResp(
      goals: (json['goals'] as List)
          .map((e) => GoalSummary.fromJson(e))
          .toList(),
    );
  }
}

class GoalSummary {
  final int goalId;
  final String title;
  final String content;
  final DateTime? arrivalDate;
  final bool isLocked;
  final bool isArrived;
  final bool isRead;
  final DateTime createdDate;
  final String status;

  GoalSummary({
    required this.goalId,
    required this.title,
    required this.content,
    required this.arrivalDate,
    required this.isLocked,
    required this.isArrived,
    required this.isRead,
    required this.createdDate,
    required this.status,
  });

  factory GoalSummary.fromJson(Map<String, dynamic> json) {
    return GoalSummary(
      goalId: json['goalId'],
      title: json['title'],
      content: json['content'],
      arrivalDate: json['arrivalDate'] != null
          ? DateTime.parse(json['arrivalDate'])
          : null,
      isLocked: json['isLocked'],
      isArrived: json['isArrived'],
      isRead: json['isRead'],
      createdDate: DateTime.parse(json['createdDate']),
      status: json['status'],
    );
  }
}