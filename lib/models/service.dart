import 'package:service_app/models/service_category.dart';

class Service {
  int serviceId;
  int establishmentUserProfileId;
  int serviceCategoryId;
  String name;
  String description;
  double price; // Dart uses double for floating point numbers
  int estimatedDuration;
  String? serviceImage;
  bool active;
  bool deleted;
  DateTime creationDate;
  DateTime lastUpdateDate;
  ServiceCategory? serviceCategory;

  Service({
    required this.serviceId,
    required this.establishmentUserProfileId,
    required this.serviceCategoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.estimatedDuration,
    this.serviceImage,
    required this.active,
    required this.deleted,
    required this.creationDate,
    required this.lastUpdateDate,
    this.serviceCategory,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['serviceId'] as int,
      establishmentUserProfileId: json['establishmentUserProfileId'] as int,
      serviceCategoryId: json['serviceCategoryId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      estimatedDuration: json['estimatedDuration'] as int,
      serviceImage: json['serviceImage'] as String?,
      active: json['active'] as bool,
      deleted: json['deleted'] as bool,
      creationDate: DateTime.parse(json['creationDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
      serviceCategory: json['serviceCategory'] != null
          ? ServiceCategory.fromJson(
              json['serviceCategory'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'establishmentUserProfileId': establishmentUserProfileId,
      'serviceCategoryId': serviceCategoryId,
      'name': name,
      'description': description,
      'price': price,
      'estimatedDuration': estimatedDuration,
      'serviceImage': serviceImage,
      'active': active,
      'deleted': deleted,
      'creationDate': creationDate.toIso8601String(),
      'lastUpdateDate': lastUpdateDate.toIso8601String(),
      'serviceCategory': serviceCategory?.toJson(),
    };
  }
}