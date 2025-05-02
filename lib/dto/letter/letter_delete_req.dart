class LetterDeleteReq {
  final List<int> letterIds;

  LetterDeleteReq({
    required this.letterIds,
  });

  Map<String, dynamic> toJson() => {
    'letterIds': letterIds,
  };
}
