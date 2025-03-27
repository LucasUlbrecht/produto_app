import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static BoxDecoration containerDecoration = BoxDecoration(
    color: Colors.deepPurple.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
  );
}
