class LetterDetailResp {
  final int letterId;
  final String title;
  final String content;
  final DateTime? arrivalDate;
  final bool isLocked;
  final bool isArrived;
  final bool isRead;
  final DateTime? readAt;
  final String status;

  LetterDetailResp({
    required this.letterId,
    required this.title,
    required this.content,
    required this.arrivalDate,
    required this.isLocked,
    required this.isArrived,
    required this.isRead,
    required this.readAt,
    required this.status,
  });

  factory LetterDetailResp.fromJson(Map<String, dynamic> json) {
    return LetterDetailResp(
      letterId: json['letterId'],
      title: json['title'],
      content: json['content'],
      arrivalDate: json['arrivalDate'] != null
          ? DateTime.parse(json['arrivalDate'])
          : null,
      isLocked: json['isLocked'],
      isArrived: json['isArrived'],
      isRead: json['isRead'],
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'])
          : null,
      status: json['status'],
    );
  }
}