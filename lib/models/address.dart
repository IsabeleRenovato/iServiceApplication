class Address {
  int addressId;
  String street;
  String number;
  String neighborhood;
  String? additionalInfo;
  String city;
  String state;
  String country;
  String postalCode;
  bool active;
  bool deleted;
  DateTime creationDate;
  DateTime lastUpdateDate;

  Address({
    required this.addressId,
    required this.street,
    required this.number,
    required this.neighborhood,
    this.additionalInfo,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.active,
    required this.deleted,
    required this.creationDate,
    required this.lastUpdateDate,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['addressId'] as int,
      street: json['street'] as String,
      number: json['number'] as String,
      neighborhood: json['neighborhood'] as String,
      additionalInfo: json['additionalInfo'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      postalCode: json['postalCode'] as String,
      active: json['active'] as bool,
      deleted: json['deleted'] as bool,
      creationDate: DateTime.parse(json['creationDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      'street': street,
      'number': number,
      'neighborhood': neighborhood,
      'additionalInfo': additionalInfo,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'active': active,
      'deleted': deleted,
      'creationDate': creationDate.toIso8601String(),
      'lastUpdateDate': lastUpdateDate.toIso8601String(),
    };
  }
}
