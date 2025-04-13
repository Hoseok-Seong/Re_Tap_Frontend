class LoginRequest {
  final String provider;
  final String accessToken;

  LoginRequest({
    required this.provider,
    required this.accessToken,
  });

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'accessToken': accessToken,
  };
}
