import 'package:flutter/material.dart';
import '../util/constant.dart';

class DisorderDropdown extends StatelessWidget {
  final String selectedDisorder;
  final ValueChanged<String?> onChanged;

  final List<String> disorders = [
    "Alzheimers",
    "Tumors",
    "Stroke",
    "Multiple_Sclerosis"
  ];

  DisorderDropdown({
    super.key,
    required this.selectedDisorder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedDisorder.isEmpty ? null : selectedDisorder,
      decoration: InputDecoration(
        labelText: AppStrings.selectDisorder,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      items: disorders
          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
