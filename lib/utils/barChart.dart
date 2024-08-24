import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample7 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample7State();
}

class BarChartSample7State extends State<BarChartSample7> {
  final double barWidth = 22;
  final int groupsPerSlide = 3;

  List<List<BarChartGroupData>> generateQuarterlyGroups() {
    final List<BarChartGroupData> allGroups = [
      createGroupData(0, 5, 12),
      createGroupData(1, 16, 12),
      createGroupData(2, 18, 5),
      createGroupData(3, 20, 16),
      createGroupData(4, 17, 6),
      createGroupData(5, 19, 1),
      createGroupData(6, 10, 2),
      createGroupData(7, 15, 18),
      createGroupData(8, 12, 3),
      createGroupData(9, 14, 8),
      createGroupData(10, 5, 5),
      createGroupData(11, 8, 14),
    ];

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
          color: Colors.blue,
          width: barWidth,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.grey,
          width: barWidth,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  int currentQuarter = 0;

  @override
  Widget build(BuildContext context) {
    List<List<BarChartGroupData>> quarterlyGroups = generateQuarterlyGroups();

    return Column(
      children: [
        SizedBox(
          height:
              350, // Aumenta a altura para evitar o corte da legenda inferior
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 16.0), // Adiciona espaço extra na parte inferior
            child: BarChart(
              BarChartData(
                barGroups: quarterlyGroups[currentQuarter],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize:
                          30, // Garante espaço suficiente para a legenda inferior
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
                          'Dec'
                        ];
                        int monthIndex = value.toInt();
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
                      reservedSize:
                          40, // Garante espaço para os valores à direita
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
