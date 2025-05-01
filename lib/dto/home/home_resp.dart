class HomeResp {
  final int unreadCount;
  final Quote todayQuote;
  final List<RecentLetter> recentLetters;
  final List<UpcomingLetter> upcomingLetters;

  HomeResp({
    required this.unreadCount,
    required this.todayQuote,
    required this.recentLetters,
    required this.upcomingLetters,
  });

  factory HomeResp.fromJson(Map<String, dynamic> json) {
    return HomeResp(
      unreadCount: json['unreadCount'],
      todayQuote: Quote.fromJson(json['todayQuote']),
      recentLetters: (json['recentLetters'] as List)
          .map((e) => RecentLetter.fromJson(e))
          .toList(),
      upcomingLetters: (json['upcomingLetters'] as List)
          .map((e) => UpcomingLetter.fromJson(e))
          .toList(),
    );
  }
}

class Quote {
  final String no;
  final String author;
  final String krContent;
  final String enContent;
  final String subject;

  Quote({
    required this.no,
    required this.author,
    required this.krContent,
    required this.enContent,
    required this.subject,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      no: json['no'],
      author: json['author'],
      krContent: json['krContent'],
      enContent: json['enContent'],
      subject: json['subject'],
    );
  }
}

class RecentLetter {
  final String title;
  final DateTime createdAt;

  RecentLetter({
    required this.title,
    required this.createdAt,
  });

  factory RecentLetter.fromJson(Map<String, dynamic> json) {
    return RecentLetter(
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class UpcomingLetter {
  final String title;
  final DateTime arrivalDate;

  UpcomingLetter({
    required this.title,
    required this.arrivalDate,
  });

  factory UpcomingLetter.fromJson(Map<String, dynamic> json) {
    return UpcomingLetter(
      title: json['title'],
      arrivalDate: DateTime.parse(json['arrivalDate']),
    );
  }
}
