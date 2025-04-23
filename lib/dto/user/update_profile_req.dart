class UpdateProfileReq {
  final String nickname;

  UpdateProfileReq({
    required this.nickname,
  });

  Map<String, dynamic> toJson() => {
    'nickname': nickname,
  };
}
