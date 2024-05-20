class EstablishmentCategory {
  int establishmentCategoryId;
  String name;
  bool active;
  bool deleted;
  DateTime creationDate;
  DateTime lastUpdateDate;

  EstablishmentCategory({
    required this.establishmentCategoryId,
    required this.name,
    required this.active,
    required this.deleted,
    required this.creationDate,
    required this.lastUpdateDate,
  });

  factory EstablishmentCategory.fromJson(Map<String, dynamic> json) {
    return EstablishmentCategory(
      establishmentCategoryId: json['establishmentCategoryId'] as int,
      name: json['name'] as String,
      active: json['active'] as bool,
      deleted: json['deleted'] as bool,
      creationDate: DateTime.parse(json['creationDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'establishmentCategoryId': establishmentCategoryId,
      'name': name,
      'active': active,
      'deleted': deleted,
      'creationDate': creationDate.toIso8601String(),
      'lastUpdateDate': lastUpdateDate.toIso8601String(),
    };
  }
}
