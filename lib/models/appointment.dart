import 'package:service_app/models/feedback.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/user_info.dart';

class Appointment {
  int appointmentId;
  int serviceId;
  int clientUserProfileId;
  int establishmentUserProfileId;
  int appointmentStatusId;
  DateTime start;
  DateTime end;
  bool active;
  bool deleted;
  DateTime creationDate;
  DateTime lastUpdateDate;
  UserInfo? clientUserInfo;
  UserInfo? establishmentUserInfo;
  Service? service;
  FeedbackModel? feedback;

  Appointment({
    required this.appointmentId,
    required this.serviceId,
    required this.clientUserProfileId,
    required this.establishmentUserProfileId,
    required this.appointmentStatusId,
    required this.start,
    required this.end,
    required this.active,
    required this.deleted,
    required this.creationDate,
    required this.lastUpdateDate,
    this.clientUserInfo,
    this.establishmentUserInfo,
    this.service,
    this.feedback,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointmentId'] as int,
      serviceId: json['serviceId'] as int,
      clientUserProfileId: json['clientUserProfileId'] as int,
      establishmentUserProfileId: json['establishmentUserProfileId'] as int,
      appointmentStatusId: json['appointmentStatusId'] as int,
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      active: json['active'] as bool,
      deleted: json['deleted'] as bool,
      creationDate: DateTime.parse(json['creationDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
      clientUserInfo: json['clientUserInfo'] != null
          ? UserInfo.fromJson(json['clientUserInfo'] as Map<String, dynamic>)
          : null,
      establishmentUserInfo: json['establishmentUserInfo'] != null
          ? UserInfo.fromJson(
              json['establishmentUserInfo'] as Map<String, dynamic>)
          : null,
      service: json['service'] != null
          ? Service.fromJson(json['service'] as Map<String, dynamic>)
          : null,
      feedback: json['feedback'] != null
          ? FeedbackModel.fromJson(json['feedback'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'serviceId': serviceId,
      'clientUserProfileId': clientUserProfileId,
      'establishmentUserProfileId': establishmentUserProfileId,
      'appointmentStatusId': appointmentStatusId,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'active': active,
      'deleted': deleted,
      'creationDate': creationDate.toIso8601String(),
      'lastUpdateDate': lastUpdateDate.toIso8601String(),
      'clientUserInfo': clientUserInfo?.toJson(),
      'establishmentUserInfo': establishmentUserInfo?.toJson(),
      'service': service?.toJson(),
      'feedback': feedback?.toJson(),
    };
  }
}
