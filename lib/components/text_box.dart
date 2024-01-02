import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final controller;
  final String hint;
  final bool secret;

  const TextBox({
    super.key,
    required this.controller,
    required this.hint,
    required this.secret,
  });

  @override
  Widget build(BuildContext) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: secret,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hint,
        ),
      ),
    );
  }
}