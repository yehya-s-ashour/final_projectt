import 'package:flutter/material.dart';

Padding CustomTextField({
  required String validationMessage,
  required String hintText,
  required Color hintTextColor,
  required bool isPrefixIcon,
  required bool isSuffixIcon,
  required bool isUnderlinedBorder,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return Padding(
    padding: const EdgeInsetsDirectional.only(
      start: 10.0,
      end: 10.0,
    ),
    child: TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
      decoration: InputDecoration(
        // Increase the left padding to make room for the suffix icon
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: InputBorder.none,
        prefixIcon: isPrefixIcon ? prefixIcon : null,
        hintText: hintText,
        suffixIcon: isSuffixIcon ? suffixIcon : null,
        hintStyle: TextStyle(
          color: hintTextColor,
          fontFamily: 'Iphone',
          fontSize: 19,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: isUnderlinedBorder
            ? UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300))
            : null,
      ),
    ),
  );
}
