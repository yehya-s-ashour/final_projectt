import 'package:flutter/material.dart';

void showAlert(context,
    {required String message,
    required Color color,
    required double width,
    bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ),
    
    duration: const Duration(seconds: 2),       
    backgroundColor: color,
    width: width,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
  ));
}
