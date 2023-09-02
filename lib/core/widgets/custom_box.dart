import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';

Container CustomBox(
    {required Color color, required String number, required String status}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    width: 181,
    height: 88,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: boxColor,
      boxShadow: [
        BoxShadow(
          color: shadowColor, // Shadow color
          spreadRadius: 5, // Spread radius
          blurRadius: 7, // Blur radius
          offset: Offset(0, 3), // Offset to control the position of the shadow
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(12)),
              ),
              Text(
                number,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Text(
            status,
            style: TextStyle(fontSize: 24, color: Colors.grey),
          )
        ],
      ),
    ),
  );
}
