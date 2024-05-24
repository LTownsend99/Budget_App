import 'package:budget_app/components/expense_summary.dart';
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
  final newExpensePoundController = TextEditingController();
  final newExpensePenceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

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
                    decoration: const InputDecoration(
                      hintText: "Expense Name",
                    ),
                  ),
                  // expense amount
                  Row(
                    children: [
                      //pounds
                      Expanded(
                        child: TextField(
                          controller: newExpensePoundController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Pounds",
                          ),
                        ),
                      ),

                      //pence
                      Expanded(
                        child: TextField(
                          controller: newExpensePenceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Pence",
                          ),
                        ),
                      ),
                    ],
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

  // delete expense

  void deleteExpense(ExpenseItem expenseItem) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expenseItem);
  }

  void save() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpensePoundController.text.isNotEmpty &&
        newExpensePenceController.text.isNotEmpty) {

      String amount =
          newExpensePoundController.text + '.' + newExpensePenceController.text;
      ExpenseItem newExpenseItem = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );

      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpenseItem);
    }

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpensePoundController.clear();
    newExpensePenceController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: addNewExpense,
            child: Icon(Icons.add),
          ),
          body: ListView(
            children: [
              //weekly summary
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),

              //expense List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getOverallExpenses().length,
                itemBuilder: (context, index) => ExpenseTile(
                  name: value.getOverallExpenses()[index].name,
                  amount: value.getOverallExpenses()[index].amount,
                  dateTime: value.getOverallExpenses()[index].dateTime,
                  deleteTapped: (p0) =>
                      deleteExpense(value.getOverallExpenses()[index]),
                ),
              ),
            ],
          )),
    );
  }
}
