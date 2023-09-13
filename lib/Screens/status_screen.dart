import 'dart:convert';

import 'package:final_projectt/Screens/main_screen.dart';
import 'package:final_projectt/core/services/catego_controller.dart';
import 'package:final_projectt/core/services/status_controller.dart';

import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/models/catego_model.dart';

import 'package:final_projectt/models/status_single.dart';
import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  final String nameOfStatus;
  final int idOfStatus;
  const StatusScreen(
      {super.key, required this.nameOfStatus, required this.idOfStatus});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  late Future<StatusSingle> statusSingle;
  StatusSingle? statusSingledata;
  StatusSingle? singleMails;

  late Future<List<CategoryElement>> categories;
  List<CategoryElement>? categoData;

  @override
  void initState() {
    categories = getCatego();

    statusSingle = StatusController().fetchSingleStatuse(widget.idOfStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF7F6FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF7F6FF),
        title: Text(
          widget.nameOfStatus,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const MainPage();
            }));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff6589FF),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder(
                future: categories,
                builder: (context, AsyncSnapshot firstSnapshot) {
                  if (firstSnapshot.hasData) {
                    categoData = firstSnapshot.data;
                    return Column(
                      children: categoData!.map((e) {
                        return FutureBuilder(
                            future: statusSingle,
                            builder: (context, AsyncSnapshot secondSnapshot) {
                              if (secondSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (secondSnapshot.hasError) {
                                return Text('Error: ${secondSnapshot.error}');
                              } else {
                                statusSingledata = secondSnapshot.data;
                                return Column(
                                  children: categoData!.map((catego) {
                                    String nameOfCatego = catego.name;
                                    int idOfCatego = catego.id;
                                    if (idOfCatego == e.id) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent),
                                        child: ExpansionTile(
                                            onExpansionChanged: (value) {},
                                            trailing:
                                                Icon(Icons.arrow_back_ios),
                                            childrenPadding:
                                                const EdgeInsetsDirectional
                                                    .only(top: 16, bottom: 16),
                                            textColor: const Color(0xff272727),
                                            tilePadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16),
                                            initiallyExpanded: true,
                                            title: Text(
                                              nameOfCatego,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            children: statusSingledata!
                                                .status!.mails!
                                                .where((element) =>
                                                    element
                                                        .sender?.categoryId ==
                                                    e.id.toString())
                                                .map((mail) {
                                              return GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 16),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    color: boxColor,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8),
                                                            width: 12,
                                                            height: 12,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: mail.status !=
                                                                        null
                                                                    ? Color(int.parse(
                                                                        mail.status!.color ??
                                                                            ""))
                                                                    : Colors
                                                                        .white),
                                                          ),
                                                          if (mail.sender !=
                                                              null)
                                                            Text(mail.sender!
                                                                    .name ??
                                                                "no data"),
                                                          const Spacer(),
                                                          Text(getMonth(
                                                              mail.createdAt ??
                                                                  "")),
                                                          const Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: Colors.grey,
                                                          )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    24.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(mail.subject!),
                                                            Text(
                                                              mail.description ??
                                                                  "no data",
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            Text(
                                                              getTag(
                                                                mail.tags,
                                                              ),
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xff6589FF)),
                                                            ),
                                                            getAttachments(mail
                                                                .attachments)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList()),
                                      );
                                    }
                                    return SizedBox(
                                      height: deviceHeight * 0.0000000000001,
                                    );
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
          ],
        ),
      ),
    );
  }
}

String getMonth(String date) {
  dynamic monthData =
      '{ "01" : "Jan", "02" : "Feb", "03" : "Mar", "04" : "Apr", "05" : "May", "06" : "June", "07" : "Jul", "08" : "Aug", "09" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" }';
  return (date.substring(0, 5) +
      json.decode(monthData)[date.substring(5, 7)] +
      date.substring(7, 10));
}

String getTag(List<Tag>? tag) {
  String tagAsString = '';
  if (tag != null) {
    for (int j = 0; j < tag.length; j++) {
      Tag i = tag[j];
      tagAsString += "#${i.name}  ";
    }
  }
  return tagAsString;
}

Widget getAttachments(List<Attachment>? attach) {
  String? path;
  if (attach != []) {
    for (int i = 0; i < attach!.length; i++) {
      path = '${attach[i].image}';
    }
    return GestureDetector(
      onTap: () {},
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: path != null
            ? Image.network(
                'https://palmail.gsgtt.tech/storage/$path',
                fit: BoxFit.fill,
              )
            : const Text(''),
      ),
    );
  }
  return const Text('');
}
