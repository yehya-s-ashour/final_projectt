import 'package:final_projectt/Screens/tags_screen.dart';
import 'package:final_projectt/core/services/catego_controller.dart';
import 'package:final_projectt/core/services/mail_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/models/catego_model.dart';
import 'package:final_projectt/models/mail_model.dart';
import 'package:flutter/material.dart';

import '../core/widgets/card.dart';
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
  late Future<List<CategoryElement>> categories;
  late Future<List<MailElement>> mails;

  @override
  void initState() {
    categories = getCatego();
    mails = getAllMails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic deviceHeight = MediaQuery.of(context).size.height;
    dynamic devicewidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: deviceHeight,
      width: devicewidth,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
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
                    customBox(
                        color: pendingColor, number: "9", title: "Pending")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customBox(
                        color: inProgressColor,
                        number: "9",
                        title: "In progress"),
                    customBox(
                        color: completedColor, number: "9", title: "Completed")
                  ],
                ),
                SizedBox(
                  height: deviceHeight * 0.02,
                ),
                FutureBuilder(
                    future: categories,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          height: deviceHeight * 0.4,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final name = snapshot.data?[index].name;
                              return Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  // childrenPadding: EdgeInsetsDirectional.only(bottom: 15),
                                  textColor: const Color(0xff272727),
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  initiallyExpanded: false,
                                  title: Text(
                                    name!,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: <Widget>[
                                    myCustomCard(),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 12,
                              );
                            },
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    }),
                const SizedBox(
                  height: 12,
                ),
                FutureBuilder(
                    future: mails,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          height: deviceHeight * 0.4,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final subject = snapshot.data?[index].subject;
                              return Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  // childrenPadding: EdgeInsetsDirectional.only(bottom: 15),
                                  textColor: const Color(0xff272727),
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  initiallyExpanded: false,
                                  title: Text(
                                    subject!,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber),
                                  ),
                                  children: <Widget>[
                                    myCustomCard(),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 12,
                              );
                            },
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    }),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Tags",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TagsScreen()),
                    );
                  },
                  child: Container(
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
                ),
                SizedBox(
                  height: deviceHeight * 0.06,
                )
              ],
            ),
          ),
          GestureDetector(
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
                      height: deviceHeight - 30,
                    );
                  });
                },
              ).whenComplete(() {
                setState(() {
                  xoffset = 0;
                  yoffset = 0;
                  scalefactor = 1;
                });
              });
              setState(() {
                xoffset = devicewidth * 0.12;
                yoffset = 20;
                scalefactor = 0.8;
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
    );
  }
}
