class UserRole {
  int userRoleId;
  String name;
  bool active;
  bool deleted;
  DateTime creationDate;
  DateTime lastUpdateDate;

  UserRole({
    required this.userRoleId,
    required this.name,
    required this.active,
    required this.deleted,
    required this.creationDate,
    required this.lastUpdateDate,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      userRoleId: json['userRoleId'] as int,
      name: json['name'] as String,
      active: json['active'] as bool,
      deleted: json['deleted'] as bool,
      creationDate: DateTime.parse(json['creationDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userRoleId': userRoleId,
      'name': name,
      'active': active,
      'deleted': deleted,
      'creationDate': creationDate.toIso8601String(),
      'lastUpdateDate': lastUpdateDate.toIso8601String(),
    };
  }
}
