import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BudgetPieChart extends StatelessWidget {
  final double budget;
  final double totalExpenses;

  const BudgetPieChart({
    Key? key,
    required this.budget,
    required this.totalExpenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double expensesPercentage = totalExpenses / budget * 100;
    double remainingPercentage = (budget - totalExpenses) / budget * 100;

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          swapAnimationDuration: const Duration(milliseconds: 750),
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 50,
            borderData: FlBorderData(show: false),
            sections: getSections(expensesPercentage, remainingPercentage),
          ),
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            height: 195, // Adjust this value as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BUDGET:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '£${budget.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> getSections(
      double expensesPercentage,
      double remainingPercentage,
      ) {
    return [
      PieChartSectionData(
        value: expensesPercentage,
        color: Colors.red,
        title: '${expensesPercentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      ),
      PieChartSectionData(
        value: remainingPercentage,
        color: Colors.blue,
        title: '${remainingPercentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      ),
    ];
  }
}
