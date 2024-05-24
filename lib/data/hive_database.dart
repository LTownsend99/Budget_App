import 'package:budget_app/models/expense_item.dart';
import 'package:hive_flutter/adapters.dart';

class HiveDataBase {
  final _myBox = Hive.box("expense_database");

  //write data
  void saveData(List<ExpenseItem> allExpenses) {
    // convert expense item objects into items that can be stored in the database

    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpenses) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];

      allExpensesFormatted.add(expenseFormatted);
    }

    //store list in the database
    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  // read data

  List<ExpenseItem> readData() {

    // convert database item objects into expense items

    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List <ExpenseItem> allExpenses = [];

    for(int i = 0; i < savedExpenses.length; i++)
      {
        String name = savedExpenses[i][0];
        String amount = savedExpenses[i][1];
        DateTime dateTime = savedExpenses[i][2];

        ExpenseItem expense = ExpenseItem(
            name: name,
            amount: amount,
            dateTime: dateTime);

        allExpenses.add(expense);

      }

    return allExpenses;
  }
}
