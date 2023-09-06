import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/my_overlay.dart';
import 'package:final_projectt/core/widgets/new_inbox_button_sheet.dart';
import 'package:flutter/material.dart';

import '../core/widgets/custom_tag.dart';
import '../core/widgets/my_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExpansionTileController controller = ExpansionTileController();

  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  double blurRadius = 10;
  double spreadRadius = 2.0;
  double dx = 0.0;
  double dy = 10.0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        transform: Matrix4.translationValues(xoffset, yoffset, 0)
          ..scale(scalefactor),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isdraweropen ? 20 : 0),
          color: backGroundColor,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isdraweropen
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    xoffset = 0;
                                    yoffset = 0;
                                    scalefactor = 1;
                                    isdraweropen = false;
                                    blurRadius = 10;
                                    spreadRadius = 2.0;
                                    dx = 0.0;
                                    dy = 10.0;
                                  });
                                },
                                icon: const Icon(Icons.arrow_back_ios))
                            : IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  setState(() {
                                    xoffset = 320;
                                    yoffset = 90;
                                    scalefactor = 0.8;
                                    isdraweropen = true;
                                    blurRadius = 0.0;
                                    spreadRadius = 0.0;
                                    dx = 0.0;
                                    dy = 0.0;
                                  });
                                },
                              ),
                        GestureDetector(
                          onTap: () {
                            showOverlay(context, 'Ahmed', 'admin');
                          },
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('images/person.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 24.0,
                        ),
                        filled: true,
                        fillColor: boxColor,
                        hintText: "Search",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: backGroundColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: backGroundColor),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customBox(
                          color: inboxColor,
                          number: "9",
                          title: "Inbox",
                          height: 88,
                          width: 181),
                      customBox(
                          color: pendingColor,
                          number: "9",
                          title: "Pending",
                          height: 88,
                          width: 181)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customBox(
                          color: inProgressColor,
                          number: "9",
                          title: "In progress",
                          height: 88,
                          width: 181),
                      customBox(
                          color: completedColor,
                          number: "9",
                          title: "Completed",
                          height: 88,
                          width: 181)
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      // childrenPadding: EdgeInsetsDirectional.only(bottom: 15),
                      textColor: const Color(0xff272727),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      initiallyExpanded: false,
                      title: const Text(
                        'Foreign ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: <Widget>[
                        myCustomCard(),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: const Color(0xff272727),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      initiallyExpanded: false,
                      title: const Text(
                        'Official Organization',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: <Widget>[myCustomCard()],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: const Color(0xff272727),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      initiallyExpanded: false,
                      title: const Text(
                        'NGOs',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: <Widget>[myCustomCard()],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: const Color(0xff272727),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      initiallyExpanded: true,
                      title: const Text(
                        'Others ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: <Widget>[myCustomCard()],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Tags",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        top: 8, bottom: 16, right: 16, left: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadiusDirectional.circular(16)),
                    child: Wrap(spacing: 12, children: [
                      customTag('All Tags'),
                      customTag('#Urgent'),
                      customTag('#Egyption Military'),
                      customTag('#New'),
                    ]),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                newInboxButtonSheet(context, () {
                  setState(() {
                    xoffset = 0;
                    yoffset = 0;
                    scalefactor = 1;
                  });
                });
                setState(() {
                  xoffset = MediaQuery.of(context).size.width * 0.12;
                  yoffset = 10;
                  scalefactor = 0.75;
                });
              },
              child: MyFab(
                blurRadius: blurRadius,
                spreadRadius: spreadRadius,
                dx: dx,
                dy: dy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
