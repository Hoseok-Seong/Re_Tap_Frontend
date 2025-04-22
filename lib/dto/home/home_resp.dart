class HomeResp {
  final String todayQuote;
  final String quoteAuthor;
  final String todayQuestion;
  final String? recentLetter;
  final int arrivalCount;

  HomeResp({
    required this.todayQuote,
    required this.quoteAuthor,
    required this.todayQuestion,
    required this.recentLetter,
    required this.arrivalCount,
  });
}