class RegisterResult {
  final String msg;
  final int code;
  const RegisterResult({required this.msg, required this.code});

  factory RegisterResult.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'code': int code,
        'msg': String msg,
      } =>
        RegisterResult(msg: msg, code: code),
      _ => throw const FormatException(' RegisterResult Format.error'),
    };
  }
}
