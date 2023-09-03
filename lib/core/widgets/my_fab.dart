import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';

class MyFab extends StatefulWidget {
  const MyFab({super.key});

  @override
  State<MyFab> createState() => _MyFabState();
}

class _MyFabState extends State<MyFab> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            clipBehavior: Clip.hardEdge,
            isScrollControlled: true,
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            )),
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: 700,
                );
              });
            });
      },
      child: Container(
        height: 57,
        padding: const EdgeInsetsDirectional.only(start: 30.0),
        color: boxColor,
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  color: const Color(0xff6589FF),
                  borderRadius: BorderRadiusDirectional.circular(12)),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              "New Inbox",
              style: TextStyle(
                  color: Color(0xff6589FF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
