import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:flutter/material.dart';

import '../core/widgets/custom_tag.dart';

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
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      transform: Matrix4.translationValues(xoffset, yoffset, 0)
        ..scale(scalefactor),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isdraweropen ? 20 : 0),
        color: backGroundColor,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
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
                            });
                          },
                          icon: const Icon(Icons.arrow_back_ios))
                      : IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            setState(() {
                              xoffset = 320;
                              yoffset = 90;
                              // the next line mean: home screen should be 80% of the screen before
                              scalefactor = 0.8;
                              isdraweropen = true;
                            });
                          },
                        ),
                  const CircleAvatar(
                    backgroundImage: AssetImage('images/person.jpg'),
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
                customBox(color: inboxColor, number: "9", title: "Inbox"),
                customBox(color: pendingColor, number: "9", title: "Pending")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                customBox(
                    color: inProgressColor, number: "9", title: "In progress"),
                customBox(
                    color: completedColor, number: "9", title: "Completed")
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ExpansionTile(
              textColor: const Color(0xff272727),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              initiallyExpanded: true,
              title: const Text(
                'Foreign ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[myCustomCard()],
            ),
            ExpansionTile(
              textColor: const Color(0xff272727),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              initiallyExpanded: true,
              title: const Text(
                'Official Organization',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[myCustomCard()],
            ),
            ExpansionTile(
              textColor: const Color(0xff272727),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              initiallyExpanded: false,
              title: const Text(
                'NGOs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[myCustomCard()],
            ),
            ExpansionTile(
              textColor: const Color(0xff272727),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              initiallyExpanded: true,
              title: const Text(
                'Others ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[myCustomCard()],
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Tags",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const SizedBox(
                      height: 800,
                    );
                  },
                );
              },
              child: Container(
                color: boxColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
