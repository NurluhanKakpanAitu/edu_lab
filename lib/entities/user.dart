class User {
  late String id;
  late String nickname;
  late String email;
  late int role;
  late String? photoPath;
  late String? about;

  User({
    required this.id,
    required this.nickname,
    required this.email,
    required this.role,
    this.photoPath,
    this.about,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nickname: json['nickname'],
      email: json['email'],
      role: json['role'],
      photoPath: json['photoPath'],
      about: json['about'],
    );
  }
}
