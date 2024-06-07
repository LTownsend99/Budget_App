import 'package:budget_app/components/expense_summary.dart';
import 'package:budget_app/components/expense_tile.dart';
import 'package:budget_app/data/expense_data.dart';
import 'package:budget_app/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatefulWidget
{
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _MyExpensePageState();

}

class _MyExpensePageState extends State<ExpensesPage>
{

  // Delete expense method
  void deleteExpense(ExpenseItem expenseItem) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expenseItem);
  }

  @override
  Widget build(BuildContext context)
  {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => ListView(
        children: [
          // Weekly summary
          ExpenseSummary(startOfWeek: value.startOfWeekDate()),
          const SizedBox(height: 10),
          // Expense list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.getOverallExpenses().length,
            itemBuilder: (context, index) => ExpenseTile(
              name: value.getOverallExpenses()[index].name,
              category: value.getOverallExpenses()[index].category,
              amount: value.getOverallExpenses()[index].amount,
              dateTime: value.getOverallExpenses()[index].dateTime,
              deleteTapped: (p0) =>
                  deleteExpense(value.getOverallExpenses()[index]),
            ),
          ),
        ],
      ),
    );
  }
}