class Schedule {
  int scheduleId;
  int establishmentUserProfileId;
  String days;
  String start;
  String end;
  String? breakStart;
  String? breakEnd;
  bool active;
  bool deleted;
  DateTime creationDate;
  DateTime lastUpdateDate;

  Schedule({
    required this.scheduleId,
    required this.establishmentUserProfileId,
    required this.days,
    required this.start,
    required this.end,
    this.breakStart,
    this.breakEnd,
    required this.active,
    required this.deleted,
    required this.creationDate,
    required this.lastUpdateDate,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['scheduleId'] as int,
      establishmentUserProfileId: json['establishmentUserProfileId'] as int,
      days: json['days'] as String,
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
      'scheduleId': scheduleId,
      'establishmentUserProfileId': establishmentUserProfileId,
      'days': days,
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
