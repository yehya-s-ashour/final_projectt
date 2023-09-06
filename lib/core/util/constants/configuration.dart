import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

List<Map> drawerItem = [
  {'icon': Icons.home, 'title': 'homepage'.tr()},
  {'icon': Icons.person, 'title': 'profilepage'.tr()},
  {'icon': Icons.send, 'title': 'senders'.tr()},
  {'icon': Icons.settings, 'title': 'usermanagement'.tr()},
];


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
