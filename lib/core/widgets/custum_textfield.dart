import 'package:flutter/material.dart';

Padding CustomTextField(
    {required String validationMessage,
    TextEditingController? controller,
    required String hintText,
    required Color hintTextColor,
    required bool isPrefixIcon,
    required bool isSuffixIcon,
    bool? isEnabled,
    required bool isUnderlinedBorderEnabled,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Function(String)? onChanged}) {
  return Padding(
    padding: const EdgeInsetsDirectional.only(
      start: 10.0,
      end: 10.0,
    ),
    child: TextFormField(
      onChanged: onChanged,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
      decoration: InputDecoration(
          // Increase the left padding to make room for the suffix icon
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          errorStyle: const TextStyle(fontSize: 14),
          border: InputBorder.none,
          prefixIcon: isPrefixIcon ? prefixIcon : null,
          hintText: hintText,
          suffixIcon: isSuffixIcon ? suffixIcon : null,
          hintStyle: TextStyle(
            color: hintTextColor,
            fontFamily: 'Iphone',
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          enabled: isEnabled ?? true,
          enabledBorder: isUnderlinedBorderEnabled
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300))
              : null,
          errorBorder: isUnderlinedBorderEnabled
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(
                  color: Colors.redAccent,
                ))
              : null,
          focusedBorder: isUnderlinedBorderEnabled
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300))
              : null),
    ),
  );
}
