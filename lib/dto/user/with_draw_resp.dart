class WithDrawResp {
  final String message;

  WithDrawResp({
    required this.message,
  });

  factory WithDrawResp.fromJson(Map<String, dynamic> json) {
    return WithDrawResp(
      message: json['message'],
    );
  }
}