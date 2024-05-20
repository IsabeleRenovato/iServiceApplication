class ServiceCategory {
  int serviceCategoryId;
  int establishmentUserProfileId;
  String name;
  bool active;
  bool deleted;
  DateTime creationDate;
  DateTime lastUpdateDate;

  ServiceCategory({
    required this.serviceCategoryId,
    required this.establishmentUserProfileId,
    required this.name,
    required this.active,
    required this.deleted,
    required this.creationDate,
    required this.lastUpdateDate,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      serviceCategoryId: json['serviceCategoryId'] as int,
      establishmentUserProfileId: json['establishmentUserProfileId'] as int,
      name: json['name'] as String,
      active: json['active'] as bool,
      deleted: json['deleted'] as bool,
      creationDate: DateTime.parse(json['creationDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceCategoryId': serviceCategoryId,
      'establishmentUserProfileId': establishmentUserProfileId,
      'name': name,
      'active': active,
      'deleted': deleted,
      'creationDate': creationDate.toIso8601String(),
      'lastUpdateDate': lastUpdateDate.toIso8601String(),
    };
  }
}
