class UserNameResult {
  final String msg;
  final int code;
  final String userName;
  const UserNameResult({required this.msg, required this.code,required this.userName});

  factory UserNameResult.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'code': int code,
        'msg': String msg,
        'userName': String userName
      } =>
        UserNameResult(msg: msg, code: code,userName: userName),
      _ => throw const FormatException(' UsernameResult Format.error'),
    };
  }
}
