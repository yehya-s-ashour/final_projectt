import 'package:flutter/material.dart';

void showAlert(context, {required String message, bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      child: Text(
        message,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ),
    backgroundColor: Colors.redAccent,
    duration: Duration(seconds: 2),
    width: 200,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
  ));
}
