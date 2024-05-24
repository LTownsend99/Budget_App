import 'package:budget_app/data/expense_data.dart';
import 'package:budget_app/datetime/date_time_helper.dart';
import 'package:budget_app/graphs/daily_bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;

  const ExpenseSummary({super.key, required this.startOfWeek});

  double calculateMax(
      ExpenseData value,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday,
      String sunday) {
    double? max = 100;

    List<double> values = [
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
    ];

    //sort values smallest to largest
    values.sort();

    // increase slightly so the bar is never full
    max = values.last * 1.1;

    return max == 0 ? 100 : max;
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

    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    //get yyyymmdd for each day of the week

    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
        builder: (context, value, child) => Column(
              children: [
                //week total
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      const Text(
                        'Week Total: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('\£${calculateWeekTotal(value, monday, tuesday, wednesday,
                          thursday, friday, saturday, sunday)}'),
                    ],
                  ),
                ),

                //bar graph
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
            ));
  }
}
