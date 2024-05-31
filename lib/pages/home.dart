import 'package:budget_app/components/expense_summary.dart';
import 'package:budget_app/data/expense_data.dart';
import 'package:budget_app/models/expense_item.dart';
import 'package:budget_app/pages/budgeting.dart';
import 'package:budget_app/pages/expenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpensePoundController = TextEditingController();
  final newExpensePenceController = TextEditingController();
  final GlobalKey<ExpenseSummaryState> expenseSummaryKey =
      GlobalKey<ExpenseSummaryState>();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<ExpenseData>(context, listen: false).prepareData();
      setState(() {});
    });
  }

  // Add new expense method
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Expense'),
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
            child: const Text('Save'),
          ),
          // Cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
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

  // Check if the current page is either home or expenses page
  bool isExpenseOrHomePage() {
    return selectedIndex == 0 || selectedIndex == 2;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Consumer<ExpenseData>(
        builder: (context, value, child) {
          final weekTotal =
              expenseSummaryKey.currentState?.getWeekTotal() ?? '0.00';
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    const Text(
                      'Total Week Expenses: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text('£$weekTotal', style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    Text(
                      'Total Income: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text('£100', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      const BudgetingPage(),
      const ExpensesPage(),
    ];

    List<String> pageTitles = [
      'Home',
      'Budgeting',
      'Expenses',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          pages[selectedIndex],
          Positioned(
            top: 0.0,
            right: 16.0,
            child: Visibility(
              visible: isExpenseOrHomePage(),
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: addNewExpense,
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.currency_pound), label: 'Expenses'),
        ],
      ),
    );
  }
}
