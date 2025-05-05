class UpdateProfileResp {
  final String nickname;

  UpdateProfileResp({
    required this.nickname,
  });

  factory UpdateProfileResp.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResp(
      nickname: json['nickname'],
    );
  }
}