import 'package:final_projectt/Screens/search_screen.dart';
import 'package:final_projectt/Screens/tags_screen.dart';
import 'package:final_projectt/core/services/catego_controller.dart';
import 'package:final_projectt/core/services/mail_controller.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/helpers/api_response.dart';

import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/new_inbox_button_sheet.dart';

import 'package:final_projectt/models/catego_model.dart';
import 'package:final_projectt/models/mail_model.dart';

import 'package:final_projectt/core/widgets/my_overlay.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:final_projectt/providers/status_provider.dart';
import 'package:final_projectt/providers/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/widgets/card.dart';
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
    return SafeArea(
      child: AnimatedContainer(
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
                          ///---------------------
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const SearchScreen(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },

                          icon: const Icon(Icons.search),
                        ),
                        Consumer<UserProvider>(builder: (_, userProvidor, __) {
                          if (userProvidor.data.status == Status.LOADING) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (userProvidor.data.status == Status.COMPLETED) {

                            // print(userProvidor.data.data?.user.name);

                            return GestureDetector(
                              onTap: () {
                                showOverlay(
                                    context,
                                    userProvidor.data.data!.user.name,
                                    userProvidor.data.data!.user.role!.name);
                              },
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/person.jpg'),
                              ),
                            );
                          }
                          return const Text("  no data from user provider");
                        }),
                      ],
                    ),
                  ),
                  Consumer<StatuseProvider>(builder: (_, statuseProvider, __) {
                    if (statuseProvider.statusedata.status == Status.LOADING) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (statuseProvider.statusedata.status ==
                        Status.COMPLETED) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1.5,
                              crossAxisCount:
                                  2, // Number of columns in the grid
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
                                      .tr(),
                                  height: 88,
                                  width: 181);
                            }),
                      );
                    }
                    return const Text(" no data from Statuse provider");
                  }),
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
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
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
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
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
                      "tags",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    top: Radius.circular(15.0),
                  )),
                  builder: (BuildContext context) {
                    return NewInboxBottomSheet();
                  },
                ).whenComplete(
                  () {
                    setState(() {
                      Provider.of<NewInboxProvider>(context, listen: false)
                          .clearImages();
                      Provider.of<NewInboxProvider>(context, listen: false)
                          .senderName = '';
                      Provider.of<NewInboxProvider>(context, listen: false)
                          .senderMobile = '';
                      Provider.of<NewInboxProvider>(context, listen: false)
                          .activites = [];
                      Provider.of<NewInboxProvider>(context, listen: false)
                          .isDatePickerOpened = false;
                      xoffset = 0;
                      yoffset = 0;
                      scalefactor = 1;
                    });
                  },
                );
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
