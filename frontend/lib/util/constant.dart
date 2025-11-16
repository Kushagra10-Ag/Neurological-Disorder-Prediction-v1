import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4A90E2); // calm blue
  static const Color secondary = Color(0xFF50E3C2); // soothing teal
  static const Color background = Color(0xFFF6F8FA); // soft grayish white
  static const Color resultPositive = Color(0xFF81C784); // soft green
  static const Color resultNegative = Color(0xFFB0BEC5); // neutral gray
  static const Color error = Color(0xFFE57373); // soft red for errors
  static const Color buttonText = Colors.white; // <<< add this
}

class AppStrings {
  static const appTitle = "Neurological Disorder Prediction";
  static const welcome = "Welcome!";
  static const selectDisorder = "Select Disorder";
  static const uploadMRI = "Upload MRI Image";
  static const checkButton = "Check Disorder";
}
