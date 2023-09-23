import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/services/catego_controller.dart';
import 'package:final_projectt/core/services/status_controller.dart';

import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/edit_mail_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/my_expansion_tile.dart';
import 'package:final_projectt/models/catego_model.dart';

import 'package:final_projectt/models/status_single.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
          widget.nameOfStatus.tr(),
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) {
            //   return const MainPage();
            // }));
            Navigator.pop(context);
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
                                return ShimmerList(1);
                              } else if (secondSnapshot.hasError) {
                                return Text('Error: ${secondSnapshot.error}');
                              } else {
                                statusSingledata = secondSnapshot.data;

                                return Column(
                                  children: categoData!.map((catego) {
                                    String nameOfCatego = catego.name!;
                                    int idOfCatego = catego.id!;

                                    if (idOfCatego == e.id) {
                                      int numOfMails = statusSingledata!
                                          .status!.mails!
                                          .where((element) =>
                                              element.sender?.categoryId ==
                                              e.id.toString())
                                          .length;
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent),
                                        child: MYExpansionTile(
                                            numOfMails: numOfMails,
                                            childrenPadding:
                                                const EdgeInsetsDirectional
                                                    .only(top: 16, bottom: 16),
                                            textColor: const Color(0xff272727),
                                            tilePadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16),
                                            initiallyExpanded: false,
                                            title: Text(
                                              nameOfCatego.tr(),
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
                                              return myCustomCard(mail, () {
                                                showModalBottomSheet(
                                                  clipBehavior: Clip.hardEdge,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .vertical(
                                                    top: Radius.circular(15.0),
                                                  )),
                                                  builder:
                                                      (BuildContext context) {
                                                    return EditMailBottomSheet(
                                                      mail: mail,
                                                      backScreen: widget
                                                          .nameOfStatus
                                                          .tr(),
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
                                              });
                                            }).toList()),
                                      );
                                    }
                                    return SizedBox.shrink();
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
                  return ShimmerList(4);
                }),
          ],
        ),
      ),
    );
  }
}

Widget ShimmerList(int length) {
  return SizedBox(
    height: length * 60.0, // Adjust the height to display 4 shimmer items
    child: ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 4, // Display only 4 shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(
              top: 20,
              left: 18,
              right: 18,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            height: 40,
          ),
        );
      },
    ),
  );
}
