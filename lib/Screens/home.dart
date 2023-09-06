import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/my_overlay.dart';
import 'package:final_projectt/providers/status_provider.dart';
import 'package:final_projectt/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/widgets/custom_tag.dart';
import '../core/widgets/my_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

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
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                          : context.locale.toString() == 'ar'
                              ? IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () {
                                    setState(() {
                                      xoffset = -220;
                                      yoffset = 90;
                                      scalefactor = 0.8;
                                      isdraweropen = true;
                                      blurRadius = 0.0;
                                      spreadRadius = 0.0;
                                      dx = 0.0;
                                      dy = 0.0;
                                    });
                                  },
                                )
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
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
                      Consumer<UserProvider>(builder: (_, userProvidor, __) {
                        if (userProvidor.data.status == Status.LOADING) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (userProvidor.data.status == Status.COMPLETED) {
                          print(userProvidor.data.data?.user.name);
                          return GestureDetector(
                            onTap: () {
                              showOverlay(
                                  context,
                                  userProvidor.data.data!.user.name,
                                  userProvidor.data.data!.user.role.name);
                            },
                            child: const CircleAvatar(
                              backgroundImage: AssetImage('images/person.jpg'),
                            ),
                          );
                        }
                        return const Text("  no data from user provider");
                      }),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       prefixIcon: const Icon(
                //         Icons.search,
                //         color: Colors.grey,
                //         size: 24.0,
                //       ),
                //       filled: true,
                //       fillColor: boxColor,
                //       hintText: "Search",
                //       hintStyle: const TextStyle(
                //         color: Colors.grey,
                //       ),
                //       enabledBorder: UnderlineInputBorder(
                //         borderSide: BorderSide(color: backGroundColor),
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //       focusedBorder: UnderlineInputBorder(
                //         borderRadius: BorderRadius.circular(20),
                //         borderSide: BorderSide(color: backGroundColor),
                //       ),
                //     ),
                //   ),
                // ),
                Consumer<StatuseProvider>(builder: (_, statuseProvider, __) {
                  if (statuseProvider.statusedata.status == Status.LOADING) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (statuseProvider.statusedata.status == Status.COMPLETED) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.5,
                            crossAxisCount: 2, // Number of columns in the grid
                            crossAxisSpacing: 8.0, // Spacing between columns
                            mainAxisSpacing: 8.0,
                            // Spacing between rows
                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return customBox(
                                number: statuseProvider.statusedata.data!
                                    .statuses![index].mailsCount!,
                                title: statuseProvider
                                    .statusedata.data!.statuses![index].name!
                                    .tr());
                          }),
                    );
                  }
                  return Text(" no data from Statuse provider");
                }),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     customBox(
                //         color: inboxColor, number: "9", title: "inbox".tr()),
                //     customBox(
                //         color: pendingColor, number: "9", title: "pending".tr())
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     customBox(
                //         color: inProgressColor,
                //         number: "9",
                //         title: "inprogress".tr()),
                //     customBox(
                //         color: completedColor,
                //         number: "9",
                //         title: "completed".tr())
                //   ],
                // ),
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
                    title: Text(
                      'foreign'.tr(),
                      style: const TextStyle(
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
                    title: Text(
                      'officialorganization'.tr(),
                      style: const TextStyle(
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
                    title: Text(
                      'ngos'.tr(),
                      style: const TextStyle(
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
                    title: Text(
                      'others'.tr(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[myCustomCard()],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "tags".tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
                      height: MediaQuery.of(context).size.height - 30,
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
                xoffset = MediaQuery.of(context).size.width * 0.12;
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
