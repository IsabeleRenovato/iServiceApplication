class PreRegister {
  int userRoleId;
  String email;
  String password;
  String name;

  PreRegister({
    required this.userRoleId,
    required this.email,
    required this.password,
    required this.name,
  });

  factory PreRegister.fromJson(Map<String, dynamic> json) {
    return PreRegister(
      userRoleId: json['userRoleId'] as int,
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userRoleId': userRoleId,
      'email': email,
      'password': password,
      'name': name,
    };
  }
}
