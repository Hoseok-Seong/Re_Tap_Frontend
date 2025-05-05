class LetterDeleteResp {
  final String message;

  LetterDeleteResp({
    required this.message,
  });

  factory LetterDeleteResp.fromJson(Map<String, dynamic> json) {
    return LetterDeleteResp(
      message: json['message'],
    );
  }
}