import 'package:budget_app/datetime/date_time_helper.dart';
import 'package:budget_app/models/expense_item.dart';
import 'package:flutter/cupertino.dart';

class ExpenseData extends ChangeNotifier{
  // list ALL expenses

  List<ExpenseItem> overallExpenses = [];

  //get expense list

  List<ExpenseItem> getOverallExpenses() {
    return overallExpenses;
  }

  // add new expense

  void addNewExpense(ExpenseItem expenseItem) {
    overallExpenses.add(expenseItem);

    notifyListeners();
  }

  // delete expense

  void deleteExpense(ExpenseItem expenseItem) {
    overallExpenses.remove(expenseItem);

    notifyListeners();
  }

//get weekday from a dataTime object

  String getDay(DateTime dateTime)
  {
    switch(dateTime.weekday)
    {
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

// get the date for start of the week - always find the closed sunday

  DateTime startOfWeekDate()
  {
    DateTime? startOfWeek;

    // find today's date
    DateTime today = DateTime.now();

    //find sunday by going backwards from today
    for (int i = 0; i < 7; i++)
      {
        if(getDay(today.subtract(Duration(days: i))) == 'Sunday')
          {
            startOfWeek = today.subtract(Duration(days: i));
          }
      }

    return startOfWeek!;
  }

// convert overall list into daily summary's

  Map<String,double> calculateDailyExpenseSummary()
  {
    Map<String,double> dailyExpenseSummary =
        {

        };

    for (var expense in overallExpenses)
    {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if(dailyExpenseSummary.containsKey(date))
        {
          double currentAmount = dailyExpenseSummary[date]!;
          currentAmount += amount;
          dailyExpenseSummary[date] = currentAmount;
        }
      else
        {
          dailyExpenseSummary.addAll({date: amount});
        }
    }
    return dailyExpenseSummary;
  }
}
