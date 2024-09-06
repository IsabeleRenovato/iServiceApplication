class EstablishmentEmployee {
  int establishmentEmployeeId;
  int establishmentUserProfileId;
  String name;
  String document;
  DateTime? dateOfBirth;
  String? employeeImage;
  bool active;
  bool deleted;

  EstablishmentEmployee({
    required this.establishmentEmployeeId,
    required this.establishmentUserProfileId,
    required this.name,
    required this.document,
    this.dateOfBirth,
    this.employeeImage,
    required this.active,
    required this.deleted,
  });

  // Método fromJson para criar uma instância da classe a partir de um mapa JSON
  factory EstablishmentEmployee.fromJson(Map<String, dynamic> json) {
    return EstablishmentEmployee(
      establishmentEmployeeId: json['establishmentEmployeeId'],
      establishmentUserProfileId: json['establishmentUserProfileId'],
      name: json['name'],
      document: json['document'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      employeeImage: json['employeeImage'],
      active: json['active'],
      deleted: json['deleted'],
    );
  }

  // Método toJson para converter uma instância da classe em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'establishmentEmployeeId': establishmentEmployeeId,
      'establishmentUserProfileId': establishmentUserProfileId,
      'name': name,
      'document': document,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'employeeImage': employeeImage,
      'active': active,
      'deleted': deleted,
    };
  }

  getByUserProfileId() {}
}
