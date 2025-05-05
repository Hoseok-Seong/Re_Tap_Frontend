class HomeResp {
  final int unreadCount;
  final Quote todayQuote;
  final List<RecentGoal> recentGoals;
  final List<UpcomingGoal> upcomingGoals;

  HomeResp({
    required this.unreadCount,
    required this.todayQuote,
    required this.recentGoals,
    required this.upcomingGoals,
  });

  factory HomeResp.fromJson(Map<String, dynamic> json) {
    return HomeResp(
      unreadCount: json['unreadCount'],
      todayQuote: Quote.fromJson(json['todayQuote']),
      recentGoals: (json['recentGoals'] as List)
          .map((e) => RecentGoal.fromJson(e))
          .toList(),
      upcomingGoals: (json['upcomingGoals'] as List)
          .map((e) => UpcomingGoal.fromJson(e))
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

class RecentGoal {
  final String title;
  final DateTime createdAt;

  RecentGoal({
    required this.title,
    required this.createdAt,
  });

  factory RecentGoal.fromJson(Map<String, dynamic> json) {
    return RecentGoal(
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class UpcomingGoal {
  final String title;
  final DateTime arrivalDate;

  UpcomingGoal({
    required this.title,
    required this.arrivalDate,
  });

  factory UpcomingGoal.fromJson(Map<String, dynamic> json) {
    return UpcomingGoal(
      title: json['title'],
      arrivalDate: DateTime.parse(json['arrivalDate']),
    );
  }
}
