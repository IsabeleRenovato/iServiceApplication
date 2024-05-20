class Login {
  String email;
  String password;

  Login({
    required this.email,
    required this.password,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
