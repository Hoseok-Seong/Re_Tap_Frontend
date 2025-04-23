class LetterCreateResp {
  final int letterId;

  LetterCreateResp({
    required this.letterId,
  });

  factory LetterCreateResp.fromJson(Map<String, dynamic> json) {
    return LetterCreateResp(
      letterId: json['letterId'],
    );
  }
}