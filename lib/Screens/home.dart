import 'dart:async';

import 'package:final_projectt/Screens/search_screen.dart';
import 'package:final_projectt/Screens/status_screen.dart';
import 'package:final_projectt/Screens/tags_screen.dart';
import 'package:final_projectt/core/services/catego_controller.dart';
import 'package:final_projectt/core/services/mail_controller.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/services/status_controller.dart';

import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/edit_mail_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/new_inbox_button_sheet.dart';

import 'package:final_projectt/models/catego_model.dart';
import 'package:final_projectt/models/mail_model.dart';

import 'package:final_projectt/core/widgets/my_overlay.dart';

import 'package:final_projectt/models/tags_model.dart';

import 'package:final_projectt/models/status_model.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:final_projectt/providers/status_provider.dart';

import 'package:final_projectt/providers/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/tags_controller.dart';
import '../core/widgets/my_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  double blurRadius = 10;
  double spreadRadius = 2.0;
  double dx = 0.0;
  double dy = 10.0;

  late Future<List<CategoryElement>> categories;
  late Future<MailsModel> mails;
  late Future<MailsModel> mailsOfSingleCatego;
  late Future<List<TagElement>> tags;
  List<CategoryElement>? categoData;
  MailsModel? singleMails;
  late Future<StatusesesModel> statuses;

  @override
  void initState() {
    categories = getCatego();
    mails = getMails();
    tags = getAllTags();
    statuses = StatusController().fetchStatuse();
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
                            Navigator.pushReplacement(
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
                            return GestureDetector(
                              onTap: () {
                                showOverlay(
                                    context,
                                    userProvidor.data.data!.user.name!,
                                    userProvidor.data.data!.user.role!.name!);
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://palmail.gsgtt.tech/storage/${userProvidor.data.data!.user.image}'),
                              ),
                            );
                          }
                          return const Text("  no data from user provider ");
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
                            physics: const NeverScrollableScrollPhysics(),
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
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          StatusScreen(
                                              nameOfStatus: statuseProvider
                                                  .statusedata
                                                  .data!
                                                  .statuses![index]
                                                  .name!,
                                              idOfStatus: statuseProvider
                                                  .statusedata
                                                  .data!
                                                  .statuses![index]
                                                  .id!),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;
                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: customBox(
                                    number: statuseProvider.statusedata.data!
                                        .statuses![index].mailsCount!,
                                    title: statuseProvider.statusedata.data!
                                        .statuses![index].name!
                                        .tr(),
                                    height: 88,
                                    width: 181),
                              );
                            }),
                      );
                    }

                    return const Text("  no data from Status provider ");
                  }),
                  SizedBox(
                    height: deviceHeight * 0.02,
                  ),
                  FutureBuilder(
                      future: categories,
                      builder: (context, AsyncSnapshot firstSnapshot) {
                        if (firstSnapshot.hasData) {
                          categoData = firstSnapshot.data;
                          return Column(
                            children: categoData!.map((e) {
                              return FutureBuilder(
                                  future: getMailsOfSingleCatego(e.id),
                                  builder:
                                      (context, AsyncSnapshot secondSnapshot) {
                                    if (secondSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (secondSnapshot.hasError) {
                                      return Text(
                                          'Error: ${secondSnapshot.error}');
                                    } else {
                                      singleMails = secondSnapshot.data;
                                      return Column(
                                        children: categoData!.map((catego) {
                                          String nameOfCatego = catego.name;
                                          int idOfCatego = catego.id;
                                          int numOfEmails =
                                              singleMails!.mails!.length;
                                          if (idOfCatego == e.id) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                  dividerColor:
                                                      Colors.transparent),
                                              child: ExpansionTile(
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      '$numOfEmails',
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14),
                                                    ),
                                                    const Icon(
                                                        Icons.expand_more)
                                                  ],
                                                ),
                                                childrenPadding:
                                                    const EdgeInsetsDirectional
                                                            .only(
                                                        top: 16, bottom: 16),
                                                textColor:
                                                    const Color(0xff272727),
                                                tilePadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                initiallyExpanded: false,
                                                title: Text(
                                                  nameOfCatego,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                children: singleMails!.mails!
                                                    .map((mail) {
                                                  return myCustomCard(
                                                    mail,
                                                    () {
                                                      print(mail.id);
                                                      showModalBottomSheet(
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        isScrollControlled:
                                                            true,
                                                        context: context,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                          top: Radius.circular(
                                                              15.0),
                                                        )),
                                                        builder: (BuildContext
                                                            context) {
                                                          return EditMailBottomSheet(
                                                            mail: mail,
                                                          );
                                                        },
                                                      ).whenComplete(
                                                        () {
                                                          setState(() {
                                                            Provider.of<NewInboxProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .clearImages();

                                                            Provider.of<NewInboxProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .activites = [];

                                                            tags = getAllTags();
                                                            Provider.of<NewInboxProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deletedImages = [];
                                                            xoffset = 0;
                                                            yoffset = 0;
                                                            scalefactor = 1;
                                                          });
                                                        },
                                                      );
                                                      setState(() {
                                                        xoffset = MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.12;
                                                        yoffset = 10;
                                                        scalefactor = 0.75;
                                                      });
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        }).toList(),
                                      );
                                    }
                                  });
                            }).toList(),
                          );
                        }
                        if (firstSnapshot.hasError) {
                          return Text(firstSnapshot.error.toString());
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
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Tags",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder(
                      future: tags,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<TagElement> tagsListForScreen = snapshot.data!;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TagsScreen(
                                          tagsList: tagsListForScreen,
                                        )),
                              ).then((value) {
                                if (value == true) {
                                  setState(() {
                                    categories = getCatego();
                                    mails = getMails();
                                    tags = getAllTags();
                                  });
                                }
                              });
                            },
                            child: CustomWhiteBox(
                              width: devicewidth * 0.9,
                              height: (snapshot.data!.length / 2).round() * 46,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 8.0, top: 8),
                                child: Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: snapshot.data!.map((tag) {
                                    final tagText = tag.name;
                                    final textLength = tagText.length;
                                    final tagWidth = 40.0 + (textLength * 7.0);
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TagsScreen(
                                                    tagsList: tagsListForScreen,
                                                  )),
                                        ).then((value) {
                                          if (value == true) {
                                            setState(() {
                                              categories = getCatego();
                                              mails = getMails();
                                              tags = getAllTags();
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: tagWidth,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 208, 207, 207),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Text(
                                          '# $tagText',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
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
                  SizedBox(
                    height: deviceHeight * 0.08,
                  ),
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
                      tags = getAllTags();
                      xoffset = 0;
                      yoffset = 0;
                      scalefactor = 1;
                      mails = getMails();
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
