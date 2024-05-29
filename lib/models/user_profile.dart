import 'package:service_app/models/feedback.dart';
import 'package:service_app/models/schedule.dart';

class UserProfile {
  int userProfileId;
  int userId;
  int? establishmentCategoryId; // Para estabelecimentos
  int? addressId; // Opcional para clientes
  String document;
  DateTime? dateOfBirth; // Opcional para não clientes
  String? phone;
  String? commercialName; // Opcional para não estabelecimentos
  String? commercialPhone; // Opcional para não estabelecimentos
  String? commercialEmail; // Opcional para não estabelecimentos
  String? description; // Opcional para estabelecimentos
  String? profileImage;
  DateTime creationDate;
  DateTime lastUpdateDate;
  Rating? rating;
  Schedule? schedule;

  UserProfile({
    required this.userProfileId,
    required this.userId,
    this.establishmentCategoryId,
    this.addressId,
    required this.document,
    this.dateOfBirth,
    this.phone,
    this.commercialName,
    this.commercialPhone,
    this.commercialEmail,
    this.description,
    this.profileImage,
    required this.creationDate,
    required this.lastUpdateDate,
    this.rating,
    this.schedule,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userProfileId: json['userProfileId'] as int,
      userId: json['userId'] as int,
      establishmentCategoryId: json['establishmentCategoryId'],
      addressId: json['addressId'],
      document: json['document'] as String,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      phone: json['phone'] as String?,
      commercialName: json['commercialName'] as String?,
      commercialPhone: json['commercialPhone'] as String?,
      commercialEmail: json['commercialEmail'] as String?,
      description: json['description'] as String?,
      profileImage: json['profileImage'] as String?,
      creationDate: DateTime.parse(json['creationDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,
      schedule:
          json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userProfileId': userProfileId,
      'userId': userId,
      'establishmentCategoryId': establishmentCategoryId,
      'addressId': addressId,
      'document': document,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phone': phone,
      'commercialName': commercialName,
      'commercialPhone': commercialPhone,
      'commercialEmail': commercialEmail,
      'description': description,
      'profileImage': profileImage,
      'creationDate': creationDate.toIso8601String(),
      'lastUpdateDate': lastUpdateDate.toIso8601String(),
      'rating': rating?.toJson(),
      'schedule': schedule?.toJson(),
    };
  }
}

class Rating {
  double value;
  int total;
  List<FeedbackModel> feedback;

  Rating({
    required this.value,
    required this.total,
    required this.feedback,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      value: (json['value'] as num).toDouble(),
      total: json['total'] as int,
      feedback: (json['feedback'] as List)
          .map((item) => FeedbackModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'total': total,
      'feedback': feedback.map((item) => item.toJson()).toList(),
    };
  }
}
