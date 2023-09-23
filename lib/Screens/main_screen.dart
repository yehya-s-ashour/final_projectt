import 'package:final_projectt/Screens/profile_page.dart';
import 'package:final_projectt/Screens/search_screen.dart';
import 'package:final_projectt/Screens/sender_screen.dart';
import 'package:final_projectt/Screens/status_screen.dart';
import 'package:final_projectt/Screens/tags_screen.dart';
import 'package:final_projectt/Screens/user_management_screen.dart';
import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/services/mail_controller.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/edit_mail_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/my_fab.dart';
import 'package:final_projectt/core/widgets/new_inbox_button_sheet.dart';
import 'package:final_projectt/providers/all_user_provider.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:final_projectt/providers/rtl_provider.dart';
import 'package:final_projectt/providers/status_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'dart:async';
import 'package:final_projectt/core/services/status_controller.dart';
import 'package:final_projectt/models/catego_model.dart';
import 'package:final_projectt/models/mail_model.dart';
import 'package:final_projectt/models/tags_model.dart';
import 'package:final_projectt/models/status_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../core/services/tags_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/my_overlay.dart';
import 'package:final_projectt/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../core/widgets/my_expansion_tile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoading = true;
  // late Future<List<CategoryElement>> categories;
  late Future<MailsModel> mails;
  late Future<MailsModel> mailsOfSingleCatego;
  late Future<List<TagElement>> tags;
  List<CategoryElement>? categoData;
  MailsModel? singleCategoMails;
  late Future<StatusesesModel> statuses;
  final _advancedDrawerController = AdvancedDrawerController();
  double? whiteBoxHeight;
  String? nullableValue = 'login';
  bool rtlOpening = false;
  bool undoPressed = false;

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();

    _advancedDrawerController.showDrawer();
    hideOverlay();
  }

  List<Map> categories = [
    {'name': 'Foreign', 'id': 4},
    {'name': 'NGOs', 'id': 3},
    {'name': 'Official Organiztions', 'id': 2},
    {'name': 'Others', 'id': 1},
  ];
  @override
  void initState() {
    // categories = getCatego();
    mails = getMails();
    tags = getAllTags();
    statuses = StatusController().fetchStatuse();
    super.initState();
  }

  void updateRTL(bool newValue) {
    setState(() {
      rtlOpening = newValue;
    });
  }

  List<Map> drawerItem = [
    {'icon': Icons.home, 'title': 'Home Page'},
    {'icon': Icons.person, 'title': 'Profile Page'},
    {'icon': MdiIcons.sendCheck, 'title': 'Senders'},
    {'icon': Icons.settings, 'title': 'User Management'},
  ];
  @override
  Widget build(BuildContext context) {
    dynamic deviceHeight = MediaQuery.of(context).size.height;
    dynamic devicewidth = MediaQuery.of(context).size.width;
    return AdvancedDrawer(
      backdropColor: backGroundColor,
      backdrop: Container(
        padding: EdgeInsets.zero,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: backGroundColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, primaryColor],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: Provider.of<RTLPro>(context).rtlOpening,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: backGroundColor,
      ),
      drawer: SafeArea(
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
                                onPressed: () async {
                                  switch (e["title"]) {
                                    case "Home Page":
                                      _advancedDrawerController.hideDrawer();
                                    case "Senders":
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                const SendersScreen(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(1.0, 0.0);
                                              const end = Offset.zero;
                                              const curve = Curves.easeInOut;
                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));
                                              var offsetAnimation =
                                                  animation.drive(tween);

                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: child,
                                              );
                                            },
                                          ));
                                    case "Profile Page":
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                const ProfileScreen(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(1.0, 0.0);
                                              const end = Offset.zero;
                                              const curve = Curves.easeInOut;
                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));
                                              var offsetAnimation =
                                                  animation.drive(tween);

                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: child,
                                              );
                                            },
                                          ));
                                    case "User Management":
                                      // ignore: await_only_futures
                                      int id = await Provider.of<UserProvider>(
                                              context,
                                              listen: false)
                                          .data
                                          .data!
                                          .user
                                          .role!
                                          .id!;

                                      if (id == 4) {
                                        // ignore: use_build_context_synchronously
                                        Provider.of<AllUserProvider>(context,
                                                listen: false)
                                            .UpdateAllUserProvider();
                                        // ignore: use_build_context_synchronously
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  const UserManagementScreen(),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                const begin = Offset(1.0, 0.0);
                                                const end = Offset.zero;
                                                const curve = Curves.easeInOut;
                                                var tween = Tween(
                                                        begin: begin, end: end)
                                                    .chain(CurveTween(
                                                        curve: curve));
                                                var offsetAnimation =
                                                    animation.drive(tween);

                                                return SlideTransition(
                                                  position: offsetAnimation,
                                                  child: child,
                                                );
                                              },
                                            ));
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32.0)),
                                                titlePadding:
                                                    const EdgeInsets.all(0),
                                                contentPadding:
                                                    const EdgeInsets.all(16),
                                                title: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 24),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(32),
                                                              topRight: Radius
                                                                  .circular(
                                                                      32)),
                                                      color: primaryColor),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "Entry is restricted"
                                                            .tr(),
                                                        style: const TextStyle(
                                                            fontSize: 24,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 16.0),
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  "images/images.png"),
                                                          radius: 50,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                content: Text(
                                                  "Please check with the admin to obtain access permission"
                                                      .tr(),
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("OK".tr()))
                                                ],
                                              );
                                            });
                                      }

                                      break;
                                  }
                                },
                                child: Text(
                                  "${e['title']}".tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ))
                      .toList()),
              const Spacer(),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Terms Of Service'.tr(),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 179, 178, 178),
                            fontSize: 12),
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
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: SafeArea(
          child: SizedBox(
            height: deviceHeight,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: backGroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _handleMenuButtonPressed,
                              child:
                                  ValueListenableBuilder<AdvancedDrawerValue>(
                                valueListenable: _advancedDrawerController,
                                builder: (_, value, __) {
                                  return AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: !value.visible
                                          ? context.locale.toString() == "en"
                                              ? Image.asset(
                                                  'images/drawer_icon_en.png',
                                                  key: ValueKey<bool>(
                                                      value.visible),
                                                  width: 35,
                                                  height: 30,
                                                )
                                              : Image.asset(
                                                  'images/drawer_icon_ar.png',
                                                  key: ValueKey<bool>(
                                                      value.visible),
                                                  width: 35,
                                                  height: 30,
                                                )
                                          : const Icon(
                                              Icons.clear,
                                              size: 30,
                                            ));
                                },
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const SearchScreen(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      var tween = Tween(begin: begin, end: end)
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
                              icon: const Icon(
                                Icons.search,
                                size: 25,
                              ),
                            ),
                            Consumer<UserProvider>(
                                builder: (_, userProvidor, __) {
                              if (userProvidor.data.status == Status.LOADING) {
                                return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                    ));
                              }
                              if (userProvidor.data.status ==
                                  Status.COMPLETED) {
                                return GestureDetector(
                                  onTap: () {
                                    showOverlay(
                                      context,
                                      userProvidor.data.data!.user.name!,
                                      userProvidor.data.data!.user.role!.name!
                                          .tr(),
                                      userProvidor.data.data!.user.image,
                                    );
                                  },
                                  child: Stack(children: [
                                    Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                        )),
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: userProvidor
                                                  .data.data!.user.image !=
                                              null
                                          ? NetworkImage(
                                              "https://palmail.gsgtt.tech/storage/${userProvidor.data.data!.user.image}")
                                          : const AssetImage(
                                              'images/profile.png',
                                            ) as ImageProvider<Object>,
                                    ),
                                  ]),
                                );
                              }
                              return const Text(
                                  "  no data from user provider ");
                            }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      Consumer<StatuseProvider>(
                        builder: (_, statuseProvider, __) {
                          if (statuseProvider.statusedata.status ==
                              Status.LOADING) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 2,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      height: 88,
                                      width: 181,
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                          if (statuseProvider.statusedata.status ==
                              Status.COMPLETED) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: GridView.builder(
                                // padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 2,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
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
                                                .id!,
                                          ),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(1.0, 0.0);
                                            const end = Offset.zero;
                                            const curve = Curves.easeInOut;
                                            var tween = Tween(
                                                    begin: begin, end: end)
                                                .chain(
                                                    CurveTween(curve: curve));
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
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          return const Text("  no data from Status provider ");
                        },
                      ),
                      SizedBox(
                        height: deviceHeight * 0.08,
                      ),
                      Column(
                        children: categories.map((catego) {
                          String nameOfCatego = catego['name'];
                          int idOfCatego = catego['id'];
                          return FutureBuilder(
                              future: getMailsOfSingleCatego(idOfCatego),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  singleCategoMails = snapshot.data;
                                  int numOfEmails =
                                      singleCategoMails!.mails!.length;
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent),
                                    child: MYExpansionTile(
                                      numOfMails: numOfEmails,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            nameOfCatego.tr(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      childrenPadding:
                                          const EdgeInsetsDirectional.only(
                                              top: 16, bottom: 16),
                                      textColor: const Color(0xff272727),
                                      tilePadding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      initiallyExpanded: false,
                                      children:
                                          singleCategoMails!.mails!.map((mail) {
                                        return myCustomCard(
                                          mail,
                                          () {
                                            showModalBottomSheet(
                                              clipBehavior: Clip.hardEdge,
                                              isScrollControlled: true,
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                top: Radius.circular(15.0),
                                              )),
                                              builder: (BuildContext context) {
                                                return EditMailBottomSheet(
                                                  mail: mail,
                                                );
                                              },
                                            ).whenComplete(
                                              () {
                                                setState(() {
                                                  Provider.of<NewInboxProvider>(
                                                          context,
                                                          listen: false)
                                                      .clearImages();

                                                  Provider.of<NewInboxProvider>(
                                                          context,
                                                          listen: false)
                                                      .activites = [];

                                                  Provider.of<NewInboxProvider>(
                                                          context,
                                                          listen: false)
                                                      .deletedImages = [];
                                                });
                                              },
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              });
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Tags".tr(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      FutureBuilder(
                          future: tags,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<TagElement> tagsListForScreen =
                                  snapshot.data!;
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
                                        mails = getMails();
                                        tags = getAllTags();
                                      });
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: CustomWhiteBox(
                                    width: devicewidth * 0.9,
                                    height:
                                        (snapshot.data!.length / 3).ceil() * 46,
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 8.0, top: 8),
                                      child: Wrap(
                                        spacing: 10.0,
                                        runSpacing: 10.0,
                                        children: snapshot.data!.map((tag) {
                                          final tagText = tag.name;
                                          final textLength = tagText.length;
                                          final tagWidth =
                                              40.0 + (textLength * 7.0);
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TagsScreen(
                                                          tagsList:
                                                              tagsListForScreen,
                                                        )),
                                              ).then((value) {
                                                if (value == true) {
                                                  setState(() {
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
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: devicewidth * 0.9,
                                height: 92,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: deviceHeight - (deviceHeight * 0.1)),
                  child: GestureDetector(
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
                          return const NewInboxBottomSheet();
                        },
                      ).whenComplete(
                        () {
                          setState(() {
                            Provider.of<NewInboxProvider>(context,
                                    listen: false)
                                .clearImages();
                            Provider.of<NewInboxProvider>(context,
                                    listen: false)
                                .senderName = '';
                            Provider.of<NewInboxProvider>(context,
                                    listen: false)
                                .senderMobile = '';
                            Provider.of<NewInboxProvider>(context,
                                    listen: false)
                                .activites = [];
                            Provider.of<NewInboxProvider>(context,
                                    listen: false)
                                .isDatePickerOpened = false;
                          });
                        },
                      );
                    },
                    child: const MyFab(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
