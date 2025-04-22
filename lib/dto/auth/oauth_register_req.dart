class OauthRegisterReq {
  final String provider;
  final String accessToken;

  OauthRegisterReq({
    required this.provider,
    required this.accessToken,
  });

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'accessToken': accessToken,
  };
}
