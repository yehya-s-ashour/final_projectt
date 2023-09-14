import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';

abstract class Styles {
  static UnderlineInputBorder primaryUnderlineInputBorder =
      UnderlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: primaryColor,
      width: 2,
    ),
  );

  static TextStyle textStyle14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primaryColor,
  );
}
