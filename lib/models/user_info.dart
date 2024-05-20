import 'package:service_app/models/address.dart';
import 'package:service_app/models/user.dart';
import 'package:service_app/models/user_profile.dart';
import 'package:service_app/models/user_role.dart';

class UserInfo {
  User user;
  UserRole userRole;
  UserProfile? userProfile;
  Address? address;

  UserInfo({
    required this.user,
    required this.userRole,
    this.userProfile,
    this.address,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      userRole: UserRole.fromJson(json['userRole'] as Map<String, dynamic>),
      userProfile: json['userProfile'] != null
          ? UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>)
          : null,
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'userRole': userRole.toJson(),
      'userProfile': userProfile?.toJson(),
      'address': address?.toJson(),
    };
  }
}
