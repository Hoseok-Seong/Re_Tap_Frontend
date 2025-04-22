class OauthLoginReq {
  final String provider;
  final String accessToken;

  OauthLoginReq({
    required this.provider,
    required this.accessToken,
  });

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'accessToken': accessToken,
  };
}
