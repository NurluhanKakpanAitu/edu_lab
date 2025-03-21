class Token {
  late String accessToken;
  late String refreshToken;

  Token({required this.accessToken, required this.refreshToken});

  Token.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }
}
