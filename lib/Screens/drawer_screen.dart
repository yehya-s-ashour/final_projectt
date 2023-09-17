import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/Screens/profile_page.dart';
import 'package:final_projectt/Screens/sender_screen.dart';
import 'package:final_projectt/Screens/user_management_screen.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Widget drawer(BuildContext context) {
  List<Map> drawerItem = [
    {'icon': MdiIcons.home, 'title': 'Home Page'},
    {'icon': MdiIcons.accountCard, 'title': 'Profile Page'},
    {'icon': MdiIcons.sendCheck, 'title': 'Senders'},
    {'icon': Icons.settings_applications, 'title': 'User Management'},
  ];
  return SafeArea(
    child: Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      padding: context.locale.toString() == 'ar'
          ? const EdgeInsets.only(top: 80, right: 20, bottom: 20)
          : const EdgeInsets.only(top: 80, left: 20, bottom: 20),
      color: primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: context.locale.toString() == 'ar'
                ? EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.15)
                : EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.15),
            height: 100,
            width: 100,
            child: Image.asset('images/pal.png'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Column(
              children: drawerItem
                  .map((e) => Row(
                        children: [
                          Icon(
                            e['icon'],
                            color: Colors.white,
                            size: 25,
                          ),
                          const SizedBox(
                            height: 50,
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              switch (e["title"]) {
                                case "Senders":
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const SendersScreen();
                                    },
                                  ));
                                case "Profile Page":
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ProfileScreen();
                                    },
                                  ));
                                case "User Management":
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const UserManagementScreen();
                                    },
                                  ));

                                  break;
                              }
                            },
                            child: Text(
                              "${e['title']}".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ))
                  .toList()),
          const Spacer(),
          Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Terms Of Service'.tr(),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 179, 178, 178),
                        fontSize: 13),
                  ).tr(),
                ),
                Container(
                  width: 1.2,
                  height: 15,
                  color: const Color.fromARGB(255, 179, 178, 178),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Usage Policy'.tr(),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 179, 178, 178),
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
