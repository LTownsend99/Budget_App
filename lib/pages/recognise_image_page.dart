import 'dart:developer';

import 'package:budget_app/data/expense_data.dart';
import 'package:budget_app/datetime/date_time_helper.dart';
import 'package:budget_app/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:budget_app/Utils/categories.dart';

class RecogniseImagePage extends StatefulWidget {
  final String? path;

  const RecogniseImagePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecogniseImagePage> createState() => _RecogniseImagePageState();
}

class _RecogniseImagePageState extends State<RecogniseImagePage> {
  bool _isBusy = false;
  TextEditingController controller = TextEditingController();
  List<double> expenses = [];
  final newExpenseNameController = TextEditingController();
  final newExpensePoundController = TextEditingController();
  final newExpensePenceController = TextEditingController();
  final newExpenseDateController = TextEditingController();
  int selectedIndex = 0;
  String selectedCategory = 'Food & Drink';
  DateTime selectedDate = DateTime.now(); // Initialize with current date

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);
    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recognise Image Page")),
      body: _isBusy
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                maxLines: null,
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Text goes here ...",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                extractAndAddExpenses(controller.text);
              },
              child: const Text("Extract Amounts"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("£${expenses[index].toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    final RecognizedText recognizedText = await textRecognizer.processImage(image);

    controller.text = recognizedText.text;

    setState(() {
      _isBusy = false;
    });
  }

  void extractAndAddExpenses(String text) {
    final RegExp regExp = RegExp(r'£\s?(\d+(?:\.\d{1,2})?)');
    final Iterable<RegExpMatch> matches = regExp.allMatches(text);

    for (final RegExpMatch match in matches) {
      final String? amount = match.group(1);
      log(amount!);

      if (amount != null) {
        setState(() {
          expenses.add(double.parse(amount));
        });

        List<String> parts = amount.split('.');
        String pounds = parts[0];
        String pence = parts.length > 1 ? parts[1] : '00';

        // Fill the pound and pence controllers
        newExpensePoundController.text = pounds;
        newExpensePenceController.text = pence;

        // Show dialog to add the new expense
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
    }
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

      setState(() {}); // Ensure the widget rebuilds after adding a new expense
      Navigator.pop(context); // Close the dialog
      clear();

      // Navigate back to ScannerPage
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      // Show an alert dialog if fields are empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all the fields.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
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
}
