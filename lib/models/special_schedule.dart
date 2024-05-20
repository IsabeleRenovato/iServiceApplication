class SpecialSchedule {
  int specialScheduleId;
  int establishmentUserProfileId;
  DateTime date;
  String start;
  String end;
  String? breakStart;
  String? breakEnd;
  bool active;
  bool deleted;
  DateTime creationDate;
  DateTime lastUpdateDate;

  SpecialSchedule({
    required this.specialScheduleId,
    required this.establishmentUserProfileId,
    required this.date,
    required this.start,
    required this.end,
    this.breakStart,
    this.breakEnd,
    required this.active,
    required this.deleted,
    required this.creationDate,
    required this.lastUpdateDate,
  });

  factory SpecialSchedule.fromJson(Map<String, dynamic> json) {
    return SpecialSchedule(
      specialScheduleId: json['specialScheduleId'] as int,
      establishmentUserProfileId: json['establishmentUserProfileId'] as int,
      date: DateTime.parse(json['date']),
      start: json['start'] as String,
      end: json['end'] as String,
      breakStart: json['breakStart'] as String?,
      breakEnd: json['breakEnd'] as String?,
      active: json['active'] as bool,
      deleted: json['deleted'] as bool,
      creationDate: DateTime.parse(json['creationDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specialScheduleId': specialScheduleId,
      'establishmentUserProfileId': establishmentUserProfileId,
      'date': date.toIso8601String(),
      'start': start,
      'end': end,
      'breakStart': breakStart,
      'breakEnd': breakEnd,
      'active': active,
      'deleted': deleted,
      'creationDate': creationDate.toIso8601String(),
      'lastUpdateDate': lastUpdateDate.toIso8601String(),
    };
  }
}
