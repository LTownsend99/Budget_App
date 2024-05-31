import 'package:budget_app/graphs/budget_pie_chart.dart';
import 'package:flutter/material.dart';

class BudgetSummary extends StatelessWidget {
  final double budget;
  final double totalExpenses;

  BudgetSummary({super.key, required this.budget, required this.totalExpenses});

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        // Pie Chart
        SizedBox(
            height: 200,
            child: BudgetPieChart(budget: budget, totalExpenses: totalExpenses,)),
      ],
    );
  }
}


