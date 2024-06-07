import 'package:flutter/material.dart';

class CategoryColorManager {
  static final Map<String, Color> _categoryColors = {
    'Food & Drink': Colors.lightGreen,
    'Transport': Colors.lightBlueAccent,
    'Leisure': Colors.orange,
    'Utilities': Colors.grey,
    'Savings': Colors.purpleAccent,
    'Other': Colors.yellow,
    // Add more categories and corresponding colors as needed
  };

  static Color getCategoryColor(String category) {
    return _categoryColors[category] ?? Colors.black; // Default color if category not found
  }
}
