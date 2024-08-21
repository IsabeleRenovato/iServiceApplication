import 'package:service_app/models/appointment.dart';
import 'package:service_app/models/user_info.dart';

class HomeModel {
  Appointment? nextAppointment;
  UserInfo? establishment;
  UserInfo? client;
  int? totalAppointments;

  HomeModel({
    this.nextAppointment,
    this.establishment,
    this.client,
    this.totalAppointments,
  });

  // Factory method to create an instance of HomeModel from a JSON map
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      nextAppointment: json['nextAppointment'] != null
          ? Appointment.fromJson(json['nextAppointment'])
          : null,
      establishment: json['establishment'] != null
          ? UserInfo.fromJson(json['establishment'])
          : null,
      client: json['client'] != null ? UserInfo.fromJson(json['client']) : null,
      totalAppointments: json['totalAppointments'],
    );
  }

  // Method to convert the HomeModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'nextAppointment': nextAppointment?.toJson(),
      'establishment': establishment?.toJson(),
      'client': client?.toJson(),
      'totalAppointments': totalAppointments,
    };
  }
}
