import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/home.dart';
import 'package:service_app/models/monthly_report.dart';
import 'package:service_app/services/home_services.dart';
import 'package:service_app/utils/token_provider.dart';

class BarChartSample7 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample7State();
}

class BarChartSample7State extends State<BarChartSample7> {
  final double barWidth = 22;
  final int groupsPerSlide = 3;
  late HomeModel _homeModel;
  Map<String, dynamic> payload = {};
  List<MonthlyReport>? monthlyReports = [];
  bool isLoading = true;

  void didChangeDependencies() {
    super.didChangeDependencies();

    fetchDataHome().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> fetchDataHome() async {
    var tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    payload = Jwt.parseJwt(tokenProvider.token!);
    if (payload['UserId'] != null) {
      int userId = int.tryParse(payload['UserId'].toString()) ?? 0;
      await HomeServices().getHomeByUserId(userId).then((HomeModel homeModel) {
        monthlyReports = homeModel.monthlyReports;
      }).catchError((e) {
        print('Erro ao buscar UserInfo: $e ');
      });
    }
  }

  List<List<BarChartGroupData>> generateQuarterlyGroups() {
    List<BarChartGroupData> allGroups = [];

    for (var i = 0; i < monthlyReports!.length; i++) {
      final report = monthlyReports![i];
      allGroups.add(createGroupData(
          i, report.totalAppointments.toDouble(), report.averageRating));
    }

    List<List<BarChartGroupData>> quarterlyGroups = [];
    for (int i = 0; i < allGroups.length; i += groupsPerSlide) {
      int end = i + groupsPerSlide;
      if (end > allGroups.length) end = allGroups.length;
      quarterlyGroups.add(allGroups.sublist(i, end));
    }
    return quarterlyGroups;
  }

  BarChartGroupData createGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Color(0xFF2864ff),
          width: barWidth,
          borderRadius: BorderRadius.circular(4),
        ),
        /* BarChartRodData(
          toY: y2,
          color: Colors.grey,
          width: barWidth,
          borderRadius: BorderRadius.circular(4),
        ),*/
      ],
    );
  }

  int currentQuarter = 0;

  @override
  Widget build(BuildContext context) {
    List<List<BarChartGroupData>> quarterlyGroups = generateQuarterlyGroups();

    return isLoading
        ? Center(child: CircularProgressIndicator(color: Color(0xFF2864ff)))
        : Column(
            children: [
              SizedBox(
                height: 350,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: BarChart(
                    BarChartData(
                      barGroups: quarterlyGroups.isNotEmpty
                          ? quarterlyGroups[currentQuarter]
                          : [],
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const months = [
                                'Jan',
                                'Fev',
                                'Mar',
                                'Abr',
                                'Mai',
                                'Jun',
                                'Jul',
                                'Ago',
                                'Set',
                                'Out',
                                'Nov',
                                'Dez'
                              ];
                              int monthIndex = monthlyReports!.isNotEmpty
                                  ? monthlyReports![value.toInt()].month - 1
                                  : 0;
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(months[monthIndex]),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 5,
                            reservedSize: 40,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(value.toString()),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(enabled: true),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        currentQuarter =
                            (currentQuarter - 1) % quarterlyGroups.length;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      setState(() {
                        currentQuarter =
                            (currentQuarter + 1) % quarterlyGroups.length;
                      });
                    },
                  ),
                ],
              ),
            ],
          );
  }
}
