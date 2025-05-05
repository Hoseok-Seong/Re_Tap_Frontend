class GoalDeleteResp {
  final String message;

  GoalDeleteResp({
    required this.message,
  });

  factory GoalDeleteResp.fromJson(Map<String, dynamic> json) {
    return GoalDeleteResp(
      message: json['message'],
    );
  }
}