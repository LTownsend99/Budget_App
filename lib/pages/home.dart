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
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // Add new expense method
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense Name",
              ),
            ),
            // Expense amount
            Row(
              children: [
                // Pounds
                Expanded(
                  child: TextField(
                    controller: newExpensePoundController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Pounds",
                    ),
                  ),
                ),
                // Pence
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
            // Expense date
          ],
        ),
        actions: [
          // Save button
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          ),
          // Cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Delete expense method
  void deleteExpense(ExpenseItem expenseItem) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expenseItem);
  }

  // Save method
  void save() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpensePoundController.text.isNotEmpty &&
        newExpensePenceController.text.isNotEmpty) {
      String amount =
          '${newExpensePoundController.text}.${newExpensePenceController.text}';
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

  // Cancel method
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // Clear method
  void clear() {
    newExpensePoundController.clear();
    newExpensePenceController.clear();
    newExpenseNameController.clear();
  }

  // Method to handle item tap in bottom navigation bar
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Consumer<ExpenseData>(
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
                amount: value.getOverallExpenses()[index].amount,
                dateTime: value.getOverallExpenses()[index].dateTime,
                deleteTapped: (p0) =>
                    deleteExpense(value.getOverallExpenses()[index]),
              ),
            ),
          ],
        ),
      ),
      Placeholder(), // This can be your Budgeting page
    ];

    List<String> pageTitles = [
      'Home',
      'Budgeting',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: addNewExpense,
        child: Icon(Icons.add),
      ),
      body: pages[selectedIndex],
      appBar: AppBar(
        title: Text(pageTitles[selectedIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Budgeting'),
        ],
      ),
    );
  }
}
