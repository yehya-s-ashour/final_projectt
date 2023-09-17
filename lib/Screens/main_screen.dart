import 'package:final_projectt/Screens/drawer_screen.dart';
import 'package:final_projectt/core/services/mail_controller.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/edit_mail_bottom_sheet.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:final_projectt/providers/rtl_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'dart:async';
import 'package:final_projectt/core/services/status_controller.dart';
import 'package:final_projectt/models/catego_model.dart';
import 'package:final_projectt/models/mail_model.dart';
import 'package:final_projectt/models/tags_model.dart';
import 'package:final_projectt/models/status_model.dart';
import '../core/services/tags_controller.dart';
import 'package:final_projectt/Screens/search_screen.dart';
import 'package:final_projectt/Screens/status_screen.dart';
import 'package:final_projectt/Screens/tags_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/new_inbox_button_sheet.dart';
import 'package:final_projectt/core/widgets/my_overlay.dart';
import 'package:final_projectt/providers/status_provider.dart';
import 'package:final_projectt/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../core/widgets/my_fab.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // late Future<List<CategoryElement>> categories;
  // late Future<MailsModel> mails;
  late Future<MailsModel> mailsOfSingleCatego;
  late Future<List<TagElement>> tags;
  List<CategoryElement>? categoData;
  MailsModel? singleMails;
  late Future<StatusesesModel> statuses;
  final _advancedDrawerController = AdvancedDrawerController();
  bool isExpansionOpened = false;

  String? nullableValue = 'login';
  bool rtlOpening = false;
  bool positive = false;

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();

    _advancedDrawerController.showDrawer();
    hideOverlay();
  }

  List<Map> categories = [
    {'name': 'Others', 'id': 1},
    {'name': 'Official Organiztions', 'id': 2},
    {'name': 'NGOs', 'id': 3},
    {'name': 'Foreign', 'id': 4}
  ];
  @override
  void initState() {
    // categories = getCatego();
    // mails = getMails();
    tags = getAllTags();
    statuses = StatusController().fetchStatuse();
    super.initState();
  }

  void updateRTL(bool newValue) {
    setState(() {
      rtlOpening = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic deviceHeight = MediaQuery.of(context).size.height;
    dynamic devicewidth = MediaQuery.of(context).size.width;
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: drawer(context),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: _handleMenuButtonPressed,
                            icon: ValueListenableBuilder<AdvancedDrawerValue>(
                              valueListenable: _advancedDrawerController,
                              builder: (_, value, __) {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: Icon(
                                    value.visible ? Icons.clear : Icons.menu,
                                    key: ValueKey<bool>(value.visible),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
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
                            icon: const Icon(Icons.search),
                          ),
                          Consumer<UserProvider>(
                              builder: (_, userProvidor, __) {
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
                                    userProvidor.data.data!.user.role!.name!,
                                    userProvidor.data.data!.user.image!,
                                  );
                                },
                                child: CircleAvatar(
                                    backgroundImage: userProvidor
                                                .data.data!.user.image !=
                                            null
                                        ? NetworkImage(
                                            "https://palmail.gsgtt.tech/storage/${userProvidor.data.data!.user.image}")
                                        : const NetworkImage(
                                            'https://png.pngtree.com/png-vector/20190710/ourmid/pngtree-user-vector-avatar-png-image_1541962.jpg')),
                              );
                            }
                            return const Text("  no data from user provider ");
                          }),
                        ],
                      ),
                    ),
                    Consumer<StatuseProvider>(
                        builder: (_, statuseProvider, __) {
                      if (statuseProvider.statusedata.status ==
                          Status.LOADING) {
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
                                crossAxisSpacing:
                                    8.0, // Spacing between columns
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
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(),
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
                                singleMails = snapshot.data;
                                int numOfEmails = singleMails!.mails!.length;
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    title: Text(
                                      nameOfCatego,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '$numOfEmails',
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Center(
                                          child: Icon(
                                            !isExpansionOpened
                                                ? Icons
                                                    .arrow_forward_ios_rounded
                                                : Icons
                                                    .keyboard_arrow_up_rounded,
                                            size: isExpansionOpened ? 20 : 20,
                                            color: !isExpansionOpened
                                                ? Colors.grey
                                                : primaryColor,
                                          ),
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
                                    children: singleMails!.mails!.map((mail) {
                                      return myCustomCard(
                                        mail,
                                        () {
                                          showModalBottomSheet(
                                            clipBehavior: Clip.hardEdge,
                                            isScrollControlled: true,
                                            context: context,
                                            shape: const RoundedRectangleBorder(
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

                                                tags = getAllTags();
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
                              return Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              );
                            });
                      }).toList(),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Tags",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                                      // categories = getCatego();
                                      // mails = getMails();
                                      tags = getAllTags();
                                    });
                                  }
                                });
                              },
                              child: CustomWhiteBox(
                                width: devicewidth * 0.9,
                                height:
                                    (snapshot.data!.length / 2).round() * 46,
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
                                                // categories = getCatego();
                                                // mails = getMails();
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
                      return const NewInboxBottomSheet();
                    },
                  );
                  // ).whenComplete(
                  //   () {
                  //     setState(() {
                  //       Provider.of<NewInboxProvider>(context, listen: false)
                  //           .clearImages();
                  //       Provider.of<NewInboxProvider>(context, listen: false)
                  //           .senderName = '';
                  //       Provider.of<NewInboxProvider>(context, listen: false)
                  //           .senderMobile = '';
                  //       Provider.of<NewInboxProvider>(context, listen: false)
                  //           .activites = [];
                  //       Provider.of<NewInboxProvider>(context, listen: false)
                  //           .isDatePickerOpened = false;
                  //       // tags = getAllTags();
                  //       // mails = getMails();
                  //     });
                  //   },
                  // );
                },
                child: const Align(
                    alignment: Alignment.bottomCenter, child: MyFab()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
