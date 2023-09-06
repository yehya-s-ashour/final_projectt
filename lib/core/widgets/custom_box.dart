import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';

Container customBox({required String number, required String title}) {
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
                    color: title == "Inbox" || title == "الوارد"
                        ? inboxColor
                        : title == "Pending" || title == "معلقة"
                            ? pendingColor
                            : title == "In Progress" || title == "جاري المعالجة"
                                ? inProgressColor
                                : completedColor,
                    borderRadius: BorderRadius.circular(12)),
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
