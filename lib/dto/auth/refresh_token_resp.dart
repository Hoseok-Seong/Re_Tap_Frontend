class RefreshTokenResp {
  final String accessToken;
  final String refreshToken;

  RefreshTokenResp({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenResp.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResp(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}