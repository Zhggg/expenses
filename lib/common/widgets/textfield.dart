import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  const CustomTextField({
    super.key,
    required this.label,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
      ),
    );
  }
}
