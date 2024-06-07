import 'package:budget_app/data/budget_data.dart'; // Import your BudgetData class
import 'package:budget_app/data/expense_data.dart';
import 'package:budget_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {


  // Initialize Hive
  await Hive.initFlutter();

  // Open hive box
  await Hive.openBox("expense_database3");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Use MultiProvider to handle multiple providers
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseData()),
        ChangeNotifierProvider(create: (context) => BudgetData()),
        // Add BudgetData provider
      ],
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
