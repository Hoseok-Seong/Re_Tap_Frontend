class FcmTokenReq {
  final String fcmToken;

  FcmTokenReq({
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
    'fcmToken': fcmToken,
  };
}
