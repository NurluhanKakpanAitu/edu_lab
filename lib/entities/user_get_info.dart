class UserGetInfo {
  late String id;
  late String nickname;
  late String email;
  late String? photoPath;
  late String? about;

  UserGetInfo({
    required this.id,
    required this.nickname,
    required this.email,
    this.photoPath,
    this.about,
  });

  factory UserGetInfo.fromJson(Map<String, dynamic> json) {
    return UserGetInfo(
      id: json['id'],
      nickname: json['nickname'],
      email: json['email'],
      photoPath: json['photoPath'],
      about: json['about'],
    );
  }
}
