class OauthCheckResp {
  final bool isNewUser;

  OauthCheckResp({
    required this.isNewUser,
  });

  factory OauthCheckResp.fromJson(Map<String, dynamic> json) {
    return OauthCheckResp(
      isNewUser: json['isNewUser'],
    );
  }
}