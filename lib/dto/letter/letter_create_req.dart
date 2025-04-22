class LetterCreateReq {
  final String title;
  final String content;
  final bool isLocked;
  final DateTime? arrivalDate;
  final bool isSend;

  LetterCreateReq({
    required this.title,
    required this.content,
    required this.isLocked,
    this.arrivalDate,
    required this.isSend,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'isLocked': isLocked,
    'arrivalDate': arrivalDate?.toIso8601String(),
    'isSend': isSend,
  };
}
