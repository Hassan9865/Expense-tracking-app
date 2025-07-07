import 'package:daily_expense/pages/Home%20View/widget/BarGraph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final List<double> weeklySammary;
  const MyBarGraph({Key? key, required this.weeklySammary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (weeklySammary.length < 7) {
      return const Text('Insufficient data for generating the bar graph');
    }

    BarData myBarData = BarData(
      sunAmount: weeklySammary[0],
      monAmount: weeklySammary[1],
      tuesAmount: weeklySammary[2],
      wedAmount: weeklySammary[3],
      thursAmount: weeklySammary[4],
      friAmount: weeklySammary[5],
      satAmount: weeklySammary[6],
    );

    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true, getTitlesWidget: bottomTiles))),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                      toY: data.y,
                      color: Colors.red,
                      width: 25,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                          show: true, color: Colors.grey[100], toY: 100)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget bottomTiles(double value, TitleMeta meta) {
  TextStyle style = const TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text('S', style: style);
      break;
    case 1:
      text = Text('M', style: style);
      break;
    case 2:
      text = Text('T', style: style);
      break;
    case 3:
      text = Text('W', style: style);
      break;
    case 4:
      text = Text('T', style: style);
      break;
    case 5:
      text = Text('F', style: style);
      break;
    case 6:
      text = Text('S', style: style);
      break;

    default:
      text = Text(
        "",
        style: style,
      );
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
