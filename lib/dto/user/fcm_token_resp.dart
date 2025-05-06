class FcmTokenResp {
  final int userId;

  FcmTokenResp({
    required this.userId,
  });

  factory FcmTokenResp.fromJson(Map<String, dynamic> json) {
    return FcmTokenResp(
      userId: json['userId'],
    );
  }
}