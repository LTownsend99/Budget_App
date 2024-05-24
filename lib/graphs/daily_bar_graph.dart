import 'package:budget_app/graphs/bar_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyBarGraph extends StatelessWidget {
  final double? maxY;
  final double mondayAmount;
  final double tuesdayAmount;
  final double wednesdayAmount;
  final double thursdayAmount;
  final double fridayAmount;
  final double saturdayAmount;
  final double sundayAmount;

  const DailyBarGraph(
      {super.key,
      required this.maxY,
      required this.mondayAmount,
      required this.tuesdayAmount,
      required this.wednesdayAmount,
      required this.thursdayAmount,
      required this.fridayAmount,
      required this.saturdayAmount,
      required this.sundayAmount});

  @override
  Widget build(BuildContext context) {
    BarData barData = BarData(
        mondayAmount: mondayAmount,
        tuesdayAmount: tuesdayAmount,
        wednesdayAmount: wednesdayAmount,
        thursdayAmount: thursdayAmount,
        fridayAmount: fridayAmount,
        saturdayAmount: saturdayAmount,
        sundayAmount: sundayAmount);

    barData.initializeBarData();

    return BarChart(BarChartData(
      maxY: 200,
      minY: 0,
      backgroundColor: Colors.white,
      titlesData: FlTitlesData(
        show: true,
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
            getTitlesWidget: getBottomTitles))
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: true),
      barGroups: barData.barData
          .map(
            (data) => BarChartGroupData(
              x: data.x,
              barRods: [
                BarChartRodData(
                  toY: data.y,
                  color: Colors.blue,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: Colors.grey[100],
                  )
                ),
              ],
            ),
          )
          .toList(),
    ));
  }
}

Widget getBottomTitles(double value, TitleMeta meta)
{
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize:  14,
  );

  Widget text;
  switch (value.toInt())
  {
    case 0:
      text = const Text('M', style: style);
      break;
    case 1:
      text = const Text('T', style: style);
      break;
    case 2:
      text = const Text('W', style: style);
      break;
    case 3:
      text = const Text('T', style: style);
      break;
    case 4:
      text = const Text('F', style: style);
      break;
    case 5:
      text = const Text('S', style: style);
      break;
    case 6:
      text = const Text('S', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(axisSide: meta.axisSide,child: text,);
}
