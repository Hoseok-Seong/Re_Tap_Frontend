class Letter {
  final String id;
  final String title;
  final String content;
  final DateTime openDate;
  final bool isOpened;
  final String status;  // saved / sent / arrived

  Letter({
    required this.id,
    required this.title,
    required this.content,
    required this.openDate,
    required this.isOpened,
    required this.status,
  });

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      id: json['id'],
      title: json['title'],
      content: json['content'], // null 가능
      openDate: DateTime.parse(json['openDate']),
      isOpened: json['isOpened'],
      status: json['status'],
    );
  }
}