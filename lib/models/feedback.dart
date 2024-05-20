class FeedbackModel {
  int feedbackId;
  int appointmentId;
  String? description;
  double rating;
  bool active;
  bool deleted;
  DateTime creationDate;
  DateTime lastUpdateDate;
  String? name;

  FeedbackModel({
    required this.feedbackId,
    required this.appointmentId,
    this.description,
    required this.rating,
    required this.active,
    required this.deleted,
    required this.creationDate,
    required this.lastUpdateDate,
    this.name,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      feedbackId: json['feedbackId'] as int,
      appointmentId: json['appointmentId'] as int,
      description: json['description'] as String?,
      rating: json['rating'].toDouble(),
      active: json['active'] as bool,
      deleted: json['deleted'] as bool,
      creationDate: DateTime.parse(json['creationDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedbackId': feedbackId,
      'appointmentId': appointmentId,
      'description': description,
      'rating': rating,
      'active': active,
      'deleted': deleted,
      'creationDate': creationDate.toIso8601String(),
      'lastUpdateDate': lastUpdateDate.toIso8601String(),
      'name': name,
    };
  }
}
