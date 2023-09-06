import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';

Container customBox(
    {required Color color, required String number, required String title}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
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
          offset: const Offset(
              0, 3), // Offset to control the position of the shadow
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          )
        ],
      ),
    ),
  );
}

Container CustomWhiteBox({
  required double width,
  required double height,
  required Widget child,
}) {
  return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: boxColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child);
}
