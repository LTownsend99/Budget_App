import 'package:budget_app/components/budget_summary.dart';
import 'package:budget_app/components/expense_summary.dart';
import 'package:budget_app/data/expense_data.dart';
import 'package:budget_app/data/budget_data.dart';
import 'package:budget_app/datetime/date_time_helper.dart';
import 'package:budget_app/models/expense_item.dart';
import 'package:budget_app/pages/scanner.dart';
import 'package:budget_app/pages/budgeting.dart';
import 'package:budget_app/pages/expenses.dart';
import 'package:budget_app/Utils/categories.dart';
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
  final newExpenseDateController = TextEditingController();
  final GlobalKey<ExpenseSummaryState> expenseDailySummaryKey =
      GlobalKey<ExpenseSummaryState>();
  int selectedIndex = 0;
  String selectedCategory = 'Food & Drink';
  DateTime selectedDate = DateTime.now(); // Initialize with current date

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseData>(context, listen: false).prepareData();
      Provider.of<BudgetData>(context, listen: false)
          .prepareData(); // Prepare budget data
    });
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense Name",
              ),
            ),
            DropdownButtonFormField(
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newExpensePoundController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Pounds",
                    ),
                  ),
                ),
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
            // Date selection
            TextFormField(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDate: selectedDate,
                );
                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                  newExpenseDateController.text =
                      convertDateTimeToString(selectedDate);
                }
              },
              readOnly: true,
              controller: newExpenseDateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                hintText: 'Select a date',
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void save() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpensePoundController.text.isNotEmpty &&
        newExpensePenceController.text.isNotEmpty) {
      String amount =
          '${newExpensePoundController.text}.${newExpensePenceController.text}';
      ExpenseItem newExpenseItem = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: selectedDate,
        category: selectedCategory,
      );
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpenseItem);
    }

    setState(() {}); // Ensure the widget rebuilds after adding a new expense
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
    selectedCategory = categories.first;
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  bool isExpenseOrHomePage() {
    return selectedIndex == 0 || selectedIndex == 2;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Consumer2<ExpenseData, BudgetData>(
        builder: (context, expenseData, budgetData, child) {
          final budget = budgetData.getBudgetAmount();
          String totalExpenses = expenseData
              .getTotalExpenses()
              .toStringAsFixed(2); // Calculate category totals
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total Monthly Budget: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      Text('£$budget',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black)),
                    ],
                  ),
                ),
              ),
              ExpenseSummary(
                key: expenseDailySummaryKey,
                startOfWeek:
                    Provider.of<ExpenseData>(context).startOfWeekDate(),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Expenses: ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      '£$totalExpenses',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              BudgetSummary(
                budget: double.parse(budget),
                totalExpenses: double.parse(totalExpenses),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          );
        },
      ),
      const BudgetingPage(),
      const ExpensesPage(),
      const ScannerPage(),
    ];

    List<String> pageTitles = ['Home', 'Budgeting', 'Expenses', 'Scanner'];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          pages[selectedIndex],
          Positioned(
            top: 40.0,
            left: 5.0,
            child: Visibility(
              visible: isExpenseOrHomePage(),
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: addNewExpense,
                mini: true,
                child: const Icon(Icons.add, color: Colors.white,),
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(pageTitles[selectedIndex],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blueAccent,
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
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera), label: 'Scan'),
        ],
      ),
    );
  }
}
