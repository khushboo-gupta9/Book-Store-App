import 'package:flutter/material.dart';

import '../common/color_extenstion.dart';

class RoundTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconButton? suffixIcon;  // Make suffixIcon optional
  final IconButton? prefixIcon;  // Add prefixIcon
  const RoundTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,    // Accept optional suffixIcon
    this.prefixIcon, required Null Function(dynamic value) onChanged,   // Accept optional prefixIcon
  });

  @override
  State<RoundTextField> createState() => _RoundTextFieldState();
}

class _RoundTextFieldState extends State<RoundTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.textbox, 
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 15),
          
          // Use prefixIcon and suffixIcon if provided
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}
