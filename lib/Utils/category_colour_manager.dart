import 'package:flutter/material.dart';

class CategoryColorManager {
  static final Map<String, Color> _categoryColors = {
    'Food & Drink': Colors.lightGreen.shade100,
    'Transport': Colors.lightBlue.shade100,
    'Leisure': Colors.orange.shade100,
    'Utilities': Colors.red.shade100,
    'Savings': Colors.purple.shade100,
    'Other': Colors.yellow.shade100,
    // Can add more categories and corresponding colors as needed
  };

  static Color getCategoryColor(String category) {
    return _categoryColors[category] ?? Colors.white; // Default color if category not found
  }
}
