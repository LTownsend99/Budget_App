import 'package:budget_app/data/hive_database.dart';
import 'package:budget_app/models/budget_item.dart';
import 'package:flutter/cupertino.dart';

class BudgetData extends ChangeNotifier {
  // list ALL expenses

  String budget = '0.00';

  //get budget

  String getBudgetAmount() {
    return budget;
  }

  //prepare data to display
  final db = HiveDataBase();

  void prepareData() {
    budget = db.readBudgetData();
    notifyListeners();
  }

  // add new budget

  void addNewBudget(String newBudget) {

    db.saveBudget(newBudget);
    budget = newBudget;
    notifyListeners();
  }
}