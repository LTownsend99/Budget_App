import 'package:budget_app/components/expense_tile.dart';
import 'package:budget_app/data/expense_data.dart';
import 'package:budget_app/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  //addNewExpense Method
  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add New Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //expense name
                  TextField(
                    controller: newExpenseNameController,
                  ),
                  // expense amount
                  TextField(
                    controller: newExpenseAmountController,
                  ),
                  // expense date
                ],
              ),
              actions: [
                //save button
                MaterialButton(
                  onPressed: save,
                  child: Text('Save'),
                ),

                //cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: Text('Cancel'),
                )
              ],
            ));
  }

  void save() {
    ExpenseItem newExpenseItem = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );

    Provider.of<ExpenseData>(context, listen: false)
        .addNewExpense(newExpenseItem);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseAmountController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: addNewExpense,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getOverallExpenses().length,
          itemBuilder: (context, index) => ExpenseTile(
              name: value.getOverallExpenses()[index].name,
              amount: value.getOverallExpenses()[index].amount,
              dateTime: value.getOverallExpenses()[index].dateTime),
        ),
      ),
    );
  }
}
