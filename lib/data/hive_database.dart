import 'package:budget_app/models/expense_item.dart';
import 'package:hive/hive.dart';

class HiveDataBase {
  final _myBox = Hive.box("expense_database3");

  // Write data
  void saveData(List<ExpenseItem> allExpenses) {
    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpenses) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.category,
        expense.amount,
        expense.dateTime,
      ];

      allExpensesFormatted.add(expenseFormatted);
    }

    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  void saveBudget(String budget) {
    _myBox.put("BUDGET", budget);
  }

  // Read data
  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String category = savedExpenses[i][1];
      String amount = savedExpenses[i][2];
      DateTime dateTime = savedExpenses[i][3];

      ExpenseItem expense = ExpenseItem(
          name: name, amount: amount, dateTime: dateTime, category: category);

      allExpenses.add(expense);
    }

    return allExpenses;
  }

  String readBudgetData() {
    return _myBox.get("BUDGET", defaultValue: '0.00');
  }
}
