class RefreshTokenReq {
  final String refreshToken;

  RefreshTokenReq({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
    'refreshToken': refreshToken,
  };
}