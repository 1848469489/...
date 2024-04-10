class LoginResult {
  final String msg;
  final String? token;
  final int code;
  const LoginResult({this.token, required this.msg,required this.code});

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'code':int code,
        'token': String? token,
        'msg': String msg,
      } =>
        LoginResult(
          token: token,
          msg: msg,
          code: code
        ),
      _ => throw const FormatException('Format.'),
    };
  }
}