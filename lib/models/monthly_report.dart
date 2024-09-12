class MonthlyReport {
  int month;
  int totalAppointments;
  double averageRating;

  MonthlyReport({
    required this.month,
    required this.totalAppointments,
    required this.averageRating,
  });

  factory MonthlyReport.fromJson(Map<String, dynamic> json) {
    return MonthlyReport(
      month: json['month'],
      totalAppointments: json['totalAppointments'],
      averageRating: json['averageRating']
          .toDouble(), // Converte para double se necessário
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'totalAppointments': totalAppointments,
      'averageRating': averageRating,
    };
  }
}
