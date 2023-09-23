import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';

Container customBox({
  required String number,
  required String title,
}) {
  return Container(
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

Container CustomWhiteBox(
    {required double width,
    double? height,
    required Widget child,
    double? margin}) {
  return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: margin ?? 15),
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
