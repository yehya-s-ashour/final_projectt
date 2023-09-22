import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?>? myCustomDialouge<T>({
  required BuildContext context,
  required String title,
  required String content,
  required String leftChoice,
  Color? leftChoiceColor,
  Color? rightChoiceColor,
  required String rightChoice,
  required Function() rightOnPressed,
  required Function() leftOnPressed,
}) {
  showCupertinoDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.only(top: 20, bottom: 8),
        actionsPadding: EdgeInsets.zero,
        shadowColor: Colors.grey,
        contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 19,
          ),
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        actions: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 7,
                    child: TextButton(
                      onPressed: leftOnPressed,
                      child: Text(
                        leftChoice,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: leftChoiceColor ?? Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    flex: 7,
                    child: TextButton(
                      onPressed: rightOnPressed,
                      child: Text(
                        rightChoice,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: rightChoiceColor ?? Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      );
    },
  );
}
