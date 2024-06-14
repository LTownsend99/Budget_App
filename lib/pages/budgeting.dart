import 'package:budget_app/Utils/categories.dart';
import 'package:budget_app/components/budget_summary.dart';
import 'package:budget_app/components/category_colour_manager.dart';
import 'package:budget_app/data/budget_data.dart';
import 'package:budget_app/data/expense_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetingPage extends StatefulWidget {
  const BudgetingPage({super.key});

  @override
  State<BudgetingPage> createState() => _MyBudgetPageState();
}

class _MyBudgetPageState extends State<BudgetingPage> {
  final newBudgetPoundController = TextEditingController();
  final newBudgetPenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BudgetData>(context, listen: false).prepareData();
      Provider.of<ExpenseData>(context, listen: false).prepareData();
    });
  }

  void addBudget() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Add Budget Amount'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Pounds
                    Expanded(
                      child: TextField(
                        controller: newBudgetPoundController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Pounds",
                        ),
                      ),
                    ),
                    // Pence
                    Expanded(
                      child: TextField(
                        controller: newBudgetPenceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Pence",
                        ),
                      ),
                    ),
                  ],
                ),
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

  void save() {
    if (newBudgetPoundController.text.isNotEmpty &&
        newBudgetPenceController.text.isNotEmpty) {
      String amount =
          '${newBudgetPoundController.text}.${newBudgetPenceController.text}';

      Provider.of<BudgetData>(context, listen: false).addNewBudget(amount);
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
    newBudgetPoundController.clear();
    newBudgetPenceController.clear();
  }

  String remainingBudget(String budget, String expenses) {
    double sum = double.parse(budget) - double.parse(expenses);

    return sum.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => addBudget(),
        child: const Icon(Icons.add),
      ),
      body: Consumer2<BudgetData, ExpenseData>(
        builder: (context, budgetData, expenseData, child) {
          String totalExpenses = expenseData.getTotalExpenses().toStringAsFixed(2);
          String budget = budgetData.getBudgetAmount();
          String remaining = remainingBudget(budget, totalExpenses);

          Map<String, double> categoryTotals = expenseData.calculateCategoryTotals();

          // Create a mutable copy of categories list
          List<String> mutableCategories = categories.toList();
          // Sort the mutable copy based on category totals
          mutableCategories.sort((a, b) => (categoryTotals[b] ?? 0).compareTo(categoryTotals[a] ?? 0));

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Remaining Monthly Budget: ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      '£$remaining',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
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
              const SizedBox(height: 15),
              Column(
                children: mutableCategories.map((category) {
                  return ListTile(
                    tileColor: CategoryColorManager.getCategoryColor(category),
                    leading: Text(
                      category,
                      style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '£${categoryTotals[category]?.toStringAsFixed(2) ?? "0.00"}',
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
