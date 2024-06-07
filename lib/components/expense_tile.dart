import 'package:budget_app/components/category_colour_manager.dart';
import 'package:budget_app/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String category;
  final String amount;
  final DateTime dateTime;
  void Function(BuildContext)? deleteTapped;

  ExpenseTile({
    super.key,
    required this.name,
    required this.category,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Get the color for the category, defaulting to a fallback color if not found
    Color backgroundColor = CategoryColorManager.getCategoryColor(category);

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          //delete button
          SlidableAction(
            onPressed: deleteTapped,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      ),
      child: ListTile(
        // Set the background color of the ListTile based on the category
        tileColor: backgroundColor,
        leading: Text(category, style: const TextStyle(color: Colors.black, fontSize: 11)),
        title: Text(name),
        subtitle: Text(convertDateTimeToString(dateTime)),
        trailing: Text('£$amount'),
      ),
    );
  }
}
