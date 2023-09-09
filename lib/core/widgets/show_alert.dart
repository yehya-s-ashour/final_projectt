import 'package:flutter/material.dart';

void showAlert(context,
    {required String message,
    required Color color,
    required double width,
    bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: SizedBox(
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    ),
    backgroundColor: color,
    duration: Duration(seconds: 2),
    width: width,
    elevation: 6,
    behavior: SnackBarBehavior.floating,
  ));
}
