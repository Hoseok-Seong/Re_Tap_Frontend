class LetterListResp {
  final List<LetterSummary> letters;

  LetterListResp({required this.letters});

  factory LetterListResp.fromJson(Map<String, dynamic> json) {
    return LetterListResp(
      letters: (json['letters'] as List)
          .map((e) => LetterSummary.fromJson(e))
          .toList(),
    );
  }
}

class LetterSummary {
  final int letterId;
  final String title;
  final DateTime? arrivalDate;
  final bool isLocked;
  final bool isArrived;
  final bool isRead;
  final DateTime createdDate;
  final String status;

  LetterSummary({
    required this.letterId,
    required this.title,
    required this.arrivalDate,
    required this.isLocked,
    required this.isArrived,
    required this.isRead,
    required this.createdDate,
    required this.status,
  });

  factory LetterSummary.fromJson(Map<String, dynamic> json) {
    return LetterSummary(
      letterId: json['letterId'],
      title: json['title'],
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