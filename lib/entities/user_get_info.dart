class UserGetInfo {
  final String id;
  final String nickname;
  final String email;
  final String? photoPath;

  UserGetInfo({
    required this.id,
    required this.nickname,
    required this.email,
    this.photoPath,
  });

  factory UserGetInfo.fromJson(Map<String, dynamic> json) {
    return UserGetInfo(
      id: json['id'],
      nickname: json['nickname'],
      email: json['email'],
      photoPath: json['photoPath'],
    );
  }
}
