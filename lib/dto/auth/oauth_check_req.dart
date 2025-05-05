class OauthCheckReq {
  final String provider;
  final String accessToken;

  OauthCheckReq({
    required this.provider,
    required this.accessToken,
  });

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'accessToken': accessToken,
  };
}
