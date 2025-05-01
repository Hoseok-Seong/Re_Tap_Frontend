class MyPageResp {
  final int id;
  final String username;
  final String provider;
  final String nickname;
  final String role;
  final String? profileImageUrl;

  MyPageResp({
    required this.id,
    required this.username,
    required this.provider,
    required this.nickname,
    required this.role,
    required this.profileImageUrl,
  });

  factory MyPageResp.fromJson(Map<String, dynamic> json) {
    return MyPageResp(
      id: json['id'],
      username: json['username'],
      provider: json['provider'],
      nickname: json['nickname'],
      role: json['role'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}