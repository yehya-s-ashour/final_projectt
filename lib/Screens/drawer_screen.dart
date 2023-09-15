import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/Screens/profile_page.dart';
import 'package:final_projectt/Screens/sender_screen.dart';
import 'package:flutter/material.dart';

import '../core/util/constants/colors.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  List<Map> drawerItem = [
    {'icon': Icons.home, 'title': 'Home Page'},
    {'icon': Icons.person, 'title': 'Profile Page'},
    {'icon': Icons.send, 'title': 'Senders'},
    {'icon': Icons.settings, 'title': 'User Management'},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
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
                            size: 20,
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

                                  break;
                              }
                            },
                            child: Text(
                              "${e['title']} ".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                    'terms of service'.tr(),
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
                    'usagepolicy'.tr(),
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
    );
  }
}
