import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/Screens/sender_mails.dart';
import 'package:final_projectt/core/services/all_user_controller.dart';
import 'package:final_projectt/core/services/new_inbox_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/edit_sender_dialouge.dart';
import 'package:final_projectt/core/widgets/my_custom_dialouge.dart';
import 'package:final_projectt/core/widgets/show_alert.dart';

import 'package:final_projectt/models/sender_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class SendersScreen extends StatefulWidget {
  const SendersScreen({super.key});

  @override
  State<SendersScreen> createState() => _SendersScreenState();
}

class _SendersScreenState extends State<SendersScreen> {
  TextEditingController searchTextField = TextEditingController();
  late Future<Senders> senders;
  late Map<String, SingleSender> searchMap = {};
  List<MapEntry<String, SingleSender>> matchingPairs = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  dynamic sendersData;

  @override
  void initState() {
    senders = getSenders();
    initializeData();
    super.initState();
  }

  Future<Map<String, SingleSender>> initializeData() async {
    final sendersData = (await getSenders()).data;

    for (SingleSender sender in sendersData!) {
      searchMap[sender.name!] = sender;
    }
    return searchMap;
  }

  void searchSenders(String target) {
    String substring = target.toLowerCase();
    matchingPairs.clear(); // Clear the previous results

    searchMap.forEach((key, singleSender) {
      String nameLower = singleSender.name!.toLowerCase();

      if (nameLower.contains(substring)) {
        matchingPairs.add(MapEntry(key, singleSender));
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsetsDirectional.only(top: 40, start: 15, end: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(_scaffoldKey.currentContext!);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        "Senders".tr(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 10, end: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 5),
                          child: TextField(
                            controller: searchTextField,
                            onChanged: (value) {
                              searchSenders(value);
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search_rounded),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchTextField.clear();
                                  });
                                },
                                icon: const Icon(Icons.cancel),
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.05),
                              contentPadding: const EdgeInsets.all(15),
                              hintText: "Search ...".tr(),
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 19),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: backGroundColor),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: backGroundColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: senders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitPulse(
                        duration: Duration(milliseconds: 1000),
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No data available.'),
                    );
                  }

                  sendersData = snapshot.data as Senders;
                  final categorizedSenders = categorizeSenders(sendersData);
                  if (matchingPairs.isEmpty &&
                      searchTextField.text.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset('images/result_not_found.png',
                                fit: BoxFit.cover, height: 250),
                          ),
                          const SizedBox(
                            height: 70,
                          )
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    physics: const BouncingScrollPhysics(),
                    itemCount: categorizedSenders.length,
                    itemBuilder: (context, sectionIndex) {
                      final category =
                          categorizedSenders.keys.elementAt(sectionIndex);
                      final categorySenders = categorizedSenders[category]!;

                      // Filter the matchingPairs for the current category and search term
                      final filteredMatchingPairs =
                          matchingPairs.where((entry) {
                        final sender = entry.value;
                        final senderCategory =
                            sender.category!.name!.toLowerCase();
                        final senderName = sender.name!.toLowerCase();
                        final searchTerm = searchTextField.text.toLowerCase();

                        return senderCategory == category.toLowerCase() &&
                            (senderName.contains(searchTerm) ||
                                sender.mobile!.contains(searchTerm));
                      }).toList();

                      // Check if the section is empty, and skip it if so
                      if ((filteredMatchingPairs.isEmpty &&
                              categorySenders.isEmpty) ||
                          (filteredMatchingPairs.isEmpty &&
                              searchTextField.text.isNotEmpty)) {
                        return const SizedBox
                            .shrink(); // Hide the empty section
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 20),
                        child: Column(
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                            top: 20.0,
                                            start: 5,
                                          ),
                                          child: Text(
                                            category.tr(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, left: 5, right: 5),
                                          width: MediaQuery.of(
                                                  _scaffoldKey.currentContext!)
                                              .size
                                              .width,
                                          height: 1,
                                          color: Colors.grey.shade300,
                                        )
                                      ]),
                                ]),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: searchTextField.text.isNotEmpty
                                  ? filteredMatchingPairs.length
                                  : categorySenders.length,
                              itemBuilder: (context, itemIndex) {
                                final entry = searchTextField.text.isNotEmpty &&
                                        itemIndex < filteredMatchingPairs.length
                                    ? filteredMatchingPairs[itemIndex]
                                    : null;

                                final sender = searchTextField.text.isEmpty &&
                                        itemIndex < categorySenders.length
                                    ? categorySenders[itemIndex]
                                    : null;

                                if (entry != null) {
                                  return Slidable(
                                    endActionPane: ActionPane(
                                        extentRatio: 0.45,
                                        motion: const ScrollMotion(),
                                        children: [
                                          CustomSlidableAction(
                                            backgroundColor: Theme.of(
                                                    _scaffoldKey
                                                        .currentContext!)
                                                .scaffoldBackgroundColor,
                                            padding:
                                                const EdgeInsets.only(left: 30),
                                            onPressed: (context) {
                                              myCustomDialouge(
                                                  leftOnPressed: () {
                                                    Navigator.pop(_scaffoldKey
                                                        .currentContext!);
                                                  },
                                                  context: _scaffoldKey
                                                      .currentContext!,
                                                  title: 'Delete Sender?',
                                                  content:
                                                      'Are you sure want to delete "${entry.value.name}" ?',
                                                  leftChoice: 'Cancel',
                                                  rightChoice: 'Delete',
                                                  rightOnPressed: () async {
                                                    await deleteSender(
                                                            entry.value.id!)!
                                                        .then((statusCode) {
                                                      if (statusCode == 200) {
                                                        showAlert(
                                                            _scaffoldKey
                                                                .currentContext!,
                                                            message:
                                                                'Deleted Successfully',
                                                            color: primaryColor
                                                                .withOpacity(
                                                                    0.7),
                                                            width: 190);
                                                        setState(() {
                                                          senders =
                                                              getSenders();
                                                          initializeData();
                                                          Navigator.pop(_scaffoldKey
                                                              .currentContext!);
                                                        });
                                                      } else {
                                                        showAlert(
                                                            _scaffoldKey
                                                                .currentContext!,
                                                            message:
                                                                'Something went wrong',
                                                            color: Colors
                                                                .redAccent,
                                                            width: 190);
                                                        Navigator.pop(_scaffoldKey
                                                            .currentContext!);
                                                      }
                                                    });
                                                  });
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                      size: 35,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomSlidableAction(
                                            backgroundColor: Theme.of(
                                                    _scaffoldKey
                                                        .currentContext!)
                                                .scaffoldBackgroundColor,
                                            padding: EdgeInsets.zero,
                                            onPressed: (context) {
                                              showCupertinoDialog(
                                                barrierDismissible: false,
                                                context: _scaffoldKey
                                                    .currentContext!,
                                                builder:
                                                    (BuildContext context) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    child: AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                      titlePadding:
                                                          EdgeInsets.zero,
                                                      backgroundColor:
                                                          Colors.white,
                                                      title: EditSenderDialouge(
                                                        sender: entry.value,
                                                        dotThen: (value) {
                                                          setState(() {
                                                            senders =
                                                                getSenders();
                                                            initializeData();
                                                            Navigator.pop(
                                                                _scaffoldKey
                                                                    .currentContext!);
                                                            showAlert(
                                                                _scaffoldKey
                                                                    .currentContext!,
                                                                message:
                                                                    'Sender Updated',
                                                                color: primaryColor
                                                                    .withOpacity(
                                                                        0.7),
                                                                width: 150);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          Navigator.push(
                                              _scaffoldKey.currentContext!,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return SenderMails(
                                                  sender: sender);
                                            },
                                          ));
                                        });
                                      },
                                      title: Row(
                                        children: [
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          const Icon(Icons.person_3_outlined),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                entry.value.name!,
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.phone,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    entry.value.mobile!,
                                                    style: const TextStyle(
                                                        fontSize: 17),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (sender != null) {
                                  return Slidable(
                                    endActionPane: ActionPane(
                                        extentRatio: 0.45,
                                        motion: const ScrollMotion(),
                                        children: [
                                          CustomSlidableAction(
                                            backgroundColor: Theme.of(
                                                    _scaffoldKey
                                                        .currentContext!)
                                                .scaffoldBackgroundColor,
                                            padding:
                                                const EdgeInsets.only(left: 30),
                                            onPressed: (context) {
                                              myCustomDialouge(
                                                  leftOnPressed: () {
                                                    Navigator.pop(_scaffoldKey
                                                        .currentContext!);
                                                  },
                                                  context: _scaffoldKey
                                                      .currentContext!,
                                                  title: 'Delete Sender?',
                                                  content:
                                                      'Are you sure want to delete "${sender.name}" ?',
                                                  leftChoice: 'Cancel',
                                                  rightChoice: 'Delete',
                                                  rightOnPressed: () async {
                                                    await deleteSender(
                                                            sender.id!)!
                                                        .then((statusCode) {
                                                      if (statusCode == 200) {
                                                        showAlert(
                                                            _scaffoldKey
                                                                .currentContext!,
                                                            message:
                                                                'Deleted Successfully',
                                                            color: primaryColor
                                                                .withOpacity(
                                                                    0.7),
                                                            width: 190);
                                                        setState(() {
                                                          senders =
                                                              getSenders();
                                                          initializeData();
                                                          Navigator.pop(_scaffoldKey
                                                              .currentContext!);
                                                        });
                                                      } else {
                                                        showAlert(
                                                            _scaffoldKey
                                                                .currentContext!,
                                                            message:
                                                                'Something went wrong',
                                                            color: Colors
                                                                .redAccent,
                                                            width: 190);
                                                        Navigator.pop(_scaffoldKey
                                                            .currentContext!);
                                                      }
                                                    });
                                                  });
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                      size: 35,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomSlidableAction(
                                            backgroundColor: Theme.of(
                                                    _scaffoldKey
                                                        .currentContext!)
                                                .scaffoldBackgroundColor,
                                            padding: EdgeInsets.zero,
                                            onPressed: (context) {
                                              showCupertinoDialog(
                                                barrierDismissible: false,
                                                context: _scaffoldKey
                                                    .currentContext!,
                                                builder:
                                                    (BuildContext context) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                _scaffoldKey
                                                                    .currentContext!)
                                                            .viewInsets
                                                            .bottom),
                                                    child: AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                      titlePadding:
                                                          EdgeInsets.zero,
                                                      backgroundColor:
                                                          Colors.white,
                                                      title: EditSenderDialouge(
                                                        sender: sender,
                                                        dotThen: (value) {
                                                          setState(() {
                                                            senders =
                                                                getSenders();
                                                            initializeData();
                                                            Navigator.pop(
                                                                _scaffoldKey
                                                                    .currentContext!);
                                                            showAlert(
                                                                _scaffoldKey
                                                                    .currentContext!,
                                                                message:
                                                                    'Sender Updated',
                                                                color: primaryColor
                                                                    .withOpacity(
                                                                        0.7),
                                                                width: 150);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          Navigator.push(
                                              _scaffoldKey.currentContext!,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return SenderMails(
                                                  sender: sender);
                                            },
                                          ));
                                        });
                                      },
                                      title: Row(
                                        children: [
                                          const Icon(Icons.person_3_outlined),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                sender.name!,
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.phone,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    sender.mobile!,
                                                    style: const TextStyle(
                                                        fontSize: 17),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ));
  }

  // searchSenders(Senders sendersData, String searchTerm) {
  //   result.clear();
  //   for (int i = 0; i < sendersData.data.length; i++) {
  //     final sender = sendersData.data[i];
  //     final senderName = sender.name;
  //     final senderMobile = sender.mobile;

  //     if (senderMobile.contains(searchTerm) ||
  //         senderName.contains(searchTerm)) {
  //       result.addAll([senderName, senderMobile]);
  //     }
  //   }
  // }
}

Map<String, List<SingleSender>> categorizeSenders(Senders sendersData) {
  final categorizedSenders = <String, List<SingleSender>>{};

  for (final sender in sendersData.data!) {
    final category = sender.category!.name;
    if (!categorizedSenders.containsKey(category!)) {
      categorizedSenders[category] = <SingleSender>[];
    }
    categorizedSenders[category]!.add(sender);
  }

  return categorizedSenders;
}
