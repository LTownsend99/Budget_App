import 'package:budget_app/data/expense_data.dart';
import 'package:budget_app/datetime/date_time_helper.dart';
import 'package:budget_app/graphs/daily_bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseMonthlySummary extends StatefulWidget {
  final DateTime startOfMonth;

  ExpenseMonthlySummary({Key? key, required this.startOfMonth})
      : super(key: key);

  @override
  ExpenseMonthlySummaryState createState() => ExpenseMonthlySummaryState();
}

class ExpenseMonthlySummaryState extends State<ExpenseMonthlySummary> {
  String monthTotal = '0.00';

  double calculateMax(
      ExpenseData value,
      String Jan,
      String Feb,
      String Mar,
      String Apr,
      String May,
      String Jun,
      String Jul,
      String Aug,
      String Sep,
      String Oct,
      String Nov,
      String Dec) {
    double? max = 200;

    List<double> values = [
      value.calculateMonthlyExpenseSummary()[Jan] ?? 0,
      value.calculateMonthlyExpenseSummary()[Feb] ?? 0,
      value.calculateMonthlyExpenseSummary()[Mar] ?? 0,
      value.calculateMonthlyExpenseSummary()[Apr] ?? 0,
      value.calculateMonthlyExpenseSummary()[May] ?? 0,
      value.calculateMonthlyExpenseSummary()[Jun] ?? 0,
      value.calculateMonthlyExpenseSummary()[Jul] ?? 0,
      value.calculateMonthlyExpenseSummary()[Aug] ?? 0,
      value.calculateMonthlyExpenseSummary()[Sep] ?? 0,
      value.calculateMonthlyExpenseSummary()[Oct] ?? 0,
      value.calculateMonthlyExpenseSummary()[Nov] ?? 0,
      value.calculateMonthlyExpenseSummary()[Dec] ?? 0,
    ];

    // Sort values smallest to largest
    values.sort();

    // Increase slightly so the bar is never full
    max = values.last * 1.1;

    return max == 0 ? 200 : max;
  }

  String calculateMonthTotal(
    ExpenseData value,
    String Jan,
    String Feb,
    String Mar,
    String Apr,
    String May,
    String Jun,
    String Jul,
    String Aug,
    String Sep,
    String Oct,
    String Nov,
    String Dec,
  ) {
    List<double> values = [
      value.calculateMonthlyExpenseSummary()[Jan] ?? 0,
      value.calculateMonthlyExpenseSummary()[Feb] ?? 0,
      value.calculateMonthlyExpenseSummary()[Mar] ?? 0,
      value.calculateMonthlyExpenseSummary()[Apr] ?? 0,
      value.calculateMonthlyExpenseSummary()[May] ?? 0,
      value.calculateMonthlyExpenseSummary()[Jun] ?? 0,
      value.calculateMonthlyExpenseSummary()[Jul] ?? 0,
      value.calculateMonthlyExpenseSummary()[Aug] ?? 0,
      value.calculateMonthlyExpenseSummary()[Sep] ?? 0,
      value.calculateMonthlyExpenseSummary()[Oct] ?? 0,
      value.calculateMonthlyExpenseSummary()[Nov] ?? 0,
      value.calculateMonthlyExpenseSummary()[Dec] ?? 0,
    ];

    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }

    monthTotal = total.toStringAsFixed(2);
    return monthTotal;
  }

  String getMonthTotal() {
    return monthTotal;
  }

  @override
  Widget build(BuildContext context) {
    // Get yyyymmdd for each day of the week
    String Jan = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));
    String Feb = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));
    String Mar = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));
    String Apr = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));
    String May = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));
    String Jun = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));
    String Jul = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));
    String Aug = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));
    String Sep = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));
    String Oct = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));
    String Nov = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));
    String Dec = convertDateTimeToString(
        widget.startOfMonth.add(const Duration(days: 0)));

    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        // Calculate the Month total to update the weekTotal variable
        monthTotal = calculateMonthTotal(
            value, Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec);

        return Column(
          children: [
            // Week total
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total Month Expenses: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text('\£$monthTotal', style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),

            // Bar graph
            SizedBox(
                height: 200,
                child: DailyBarGraph(
                  maxY: calculateMax(value, Jan, Feb, Mar, Apr, May, Jun, Jul,
                      Aug, Sep, Oct, Nov, Dec),
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
