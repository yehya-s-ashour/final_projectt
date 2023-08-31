import 'package:flutter/material.dart';

import '../core/util/constants/colors.dart';
import '../core/util/constants/configuration.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, left: 20, bottom: 20),
      color: primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
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
                            onPressed: () {},
                            child: Text(
                              e['title'],
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
                  child: const Text(
                    'Terms of Service',
                    style: TextStyle(
                        color: Color.fromARGB(255, 179, 178, 178),
                        fontSize: 13),
                  ),
                ),
                Container(
                  width: 1.2,
                  height: 15,
                  color: const Color.fromARGB(255, 179, 178, 178),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Usage Policy',
                    style: TextStyle(
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
