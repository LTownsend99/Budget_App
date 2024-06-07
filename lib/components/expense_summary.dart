import 'package:budget_app/data/expense_data.dart';
import 'package:budget_app/datetime/date_time_helper.dart';
import 'package:budget_app/graphs/daily_bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatefulWidget {
  final DateTime startOfWeek;

  ExpenseSummary({Key? key, required this.startOfWeek}) : super(key: key);

  @override
  ExpenseSummaryState createState() => ExpenseSummaryState();
}

class ExpenseSummaryState extends State<ExpenseSummary> {
  String weekTotal = '0.00';
  double totalExpenses = 0;

  double calculateMax(
      ExpenseData value,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday,
      String sunday) {
    double? max = 200;

    List<double> values = [
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
    ];

    // Sort values smallest to largest
    values.sort();

    // Increase slightly so the bar is never full
    max = values.last * 1.1;

    return max == 0 ? 200 : max;
  }

  String calculateWeekTotal(
      ExpenseData value,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday,
      String sunday) {
    List<double> values = [
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
    ];

    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }

    weekTotal = total.toStringAsFixed(2);
    totalExpenses += double.parse(weekTotal);
    return weekTotal;
  }

  String getWeekTotal() {
    return weekTotal;
  }

  double getTotalExpenses() {
    return totalExpenses;
  }

  @override
  Widget build(BuildContext context) {
    // Get yyyymmdd for each day of the week
    String monday = convertDateTimeToString(
        widget.startOfWeek.add(const Duration(days: 0)));
    String tuesday = convertDateTimeToString(
        widget.startOfWeek.add(const Duration(days: 1)));
    String wednesday = convertDateTimeToString(
        widget.startOfWeek.add(const Duration(days: 2)));
    String thursday = convertDateTimeToString(
        widget.startOfWeek.add(const Duration(days: 3)));
    String friday = convertDateTimeToString(
        widget.startOfWeek.add(const Duration(days: 4)));
    String saturday = convertDateTimeToString(
        widget.startOfWeek.add(const Duration(days: 5)));
    String sunday = convertDateTimeToString(
        widget.startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        // Calculate the week total to update the weekTotal variable
        weekTotal = calculateWeekTotal(value, monday, tuesday, wednesday,
            thursday, friday, saturday, sunday);

        return Column(
          children: [
            // Week total
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  const Text(
                    'Total Week Expenses: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),

                  ),
                  Text('\£$weekTotal', style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),

            // Bar graph
            SizedBox(
                height: 200,
                child: DailyBarGraph(
                  maxY: calculateMax(value, monday, tuesday, wednesday,
                      thursday, friday, saturday, sunday),
                  mondayAmount:
                      value.calculateDailyExpenseSummary()[monday] ?? 0,
                  tuesdayAmount:
                      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
                  wednesdayAmount:
                      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
                  thursdayAmount:
                      value.calculateDailyExpenseSummary()[thursday] ?? 0,
                  fridayAmount:
                      value.calculateDailyExpenseSummary()[friday] ?? 0,
                  saturdayAmount:
                      value.calculateDailyExpenseSummary()[saturday] ?? 0,
                  sundayAmount:
                      value.calculateDailyExpenseSummary()[sunday] ?? 0,
                )),
          ],
        );
      },
    );
  }
}
