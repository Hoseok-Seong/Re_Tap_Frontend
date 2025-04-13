class LoginRequest {
  final String provider;
  final String accessToken;
  final String? profileImageUrl;

  LoginRequest({
    required this.provider,
    required this.accessToken,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'accessToken': accessToken,
    'profileImageUrl': profileImageUrl,
  };
}
