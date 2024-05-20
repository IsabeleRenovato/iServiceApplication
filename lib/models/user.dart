class User {
  int userId;
  int userRoleId;
  String email;
  String password;
  String name;
  DateTime creationDate;
  DateTime? lastLogin;
  DateTime lastUpdateDate;

  User({
    required this.userId,
    required this.userRoleId,
    required this.email,
    required this.password,
    required this.name,
    required this.creationDate,
    this.lastLogin,
    required this.lastUpdateDate,
  });

  // Converte um objeto JSON em um objeto User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as int,
      userRoleId: json['userRoleId'] as int,
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      creationDate: DateTime.parse(json['creationDate']),
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
    );
  }

  // Converte um objeto User em um objeto JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userRoleId': userRoleId,
      'email': email,
      'password': password,
      'name': name,
      'creationDate': creationDate.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'lastUpdateDate': lastUpdateDate.toIso8601String(),
    };
  }
}
