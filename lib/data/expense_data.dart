import 'package:budget_app/datetime/date_time_helper.dart';
import 'package:budget_app/models/expense_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:budget_app/data/hive_database.dart';

class ExpenseData extends ChangeNotifier {
  // List of all expenses
  List<ExpenseItem> overallExpenses = [];

  // Get overall expenses
  List<ExpenseItem> getOverallExpenses() {
    return overallExpenses;
  }

  // Prepare data to display
  final db = HiveDataBase();

  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenses = db.readData();
    }
  }

  // Add new expense
  void addNewExpense(ExpenseItem expenseItem) {
    overallExpenses.add(expenseItem);
    notifyListeners();
    db.saveData(overallExpenses);
  }

  // Delete expense
  void deleteExpense(ExpenseItem expenseItem) {
    overallExpenses.remove(expenseItem);
    notifyListeners();
    db.saveData(overallExpenses);
  }

  // Calculate total expenses
  double getTotalExpenses() {
    return overallExpenses.fold(
        0, (sum, item) => sum + double.parse(item.amount));
  }

  // Get weekday from a DateTime object
  String getDay(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  // Get the date for the start of the week - always find the closest Sunday
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDay(today.subtract(Duration(days: i))) == 'Monday') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  // Convert overall list into daily summaries
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenses) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }

  // Convert overall list into monthly summaries
  Map<String, double> calculateMonthlyExpenseSummary() {
    Map<String, double> monthlyExpenseSummary = {};

    for (var expense in overallExpenses) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (monthlyExpenseSummary.containsKey(date)) {
        double currentAmount = monthlyExpenseSummary[date]!;
        currentAmount += amount;
        monthlyExpenseSummary[date] = currentAmount;
      } else {
        monthlyExpenseSummary.addAll({date: amount});
      }
    }
    return monthlyExpenseSummary;
  }

  // Calculate category totals
  Map<String, double> calculateCategoryTotals() {
    Map<String, double> categoryTotals = {};

    for (var expense in overallExpenses) {
      String category = expense.category;
      double amount = double.parse(expense.amount);

      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + amount;
      } else {
        categoryTotals[category] = amount;
      }
    }

    return categoryTotals;
  }
}
