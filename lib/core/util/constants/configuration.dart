import 'package:flutter/material.dart';

///-----------tag button style-----------
ButtonStyle tagButtonStyle = ButtonStyle(
  backgroundColor: const MaterialStatePropertyAll(Color(0xffE6E6E6)),
  textStyle: const MaterialStatePropertyAll(
      TextStyle(fontSize: 14, color: Color(0xff7C7C7C))),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(16.0), // Adjust the border radius as needed
    ),
  ),
);
