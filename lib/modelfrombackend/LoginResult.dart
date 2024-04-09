class LoginResult {
  final String userName;
  final String token;

  const LoginResult({required this.token, required this.userName});

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'token': String token,
        'username': String userName,
      } =>
        LoginResult(
          token: token,
          userName: userName,
        ),
      _ => throw const FormatException('Format.'),
    };
  }
}