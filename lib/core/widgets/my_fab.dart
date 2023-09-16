// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:final_projectt/core/util/constants/colors.dart';

class MyFab extends StatefulWidget {
  const MyFab({
    Key? key,
  }) : super(key: key);

  @override
  State<MyFab> createState() => _MyFabState();
}

class _MyFabState extends State<MyFab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.065,
      padding: const EdgeInsetsDirectional.only(start: 30.0),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
        color: boxColor,
      ),
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
          Text(
            "newinbox".tr(),
            style: const TextStyle(
                color: Color(0xff6589FF),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
