import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/services/search_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/edit_mail_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/filter_bottom_sheet.dart';
import 'package:final_projectt/models/search_model.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final String? text;
  final int? statuId;
  final DateTime? startDate;
  final DateTime? endDate;
  const SearchScreen(
      {super.key, this.statuId, this.startDate, this.endDate, this.text});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<Search>? searchData;
  //MySearchController mySearchController = MySearchController();
  TextEditingController searchController = TextEditingController();
  //Search? mail;

  @override
  void initState() {
    if (widget.text != null && widget.text != "") {
      searchController.text = widget.text!;
      searchData = MySearchController().fetchSearchData(searchController.text,
          end: widget.endDate != null ? widget.endDate.toString() : "",
          start: widget.startDate != null ? widget.startDate.toString() : "",
          status_id: widget.statuId != null ? widget.statuId.toString() : "");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F6FF),
      appBar: AppBar(
        title: Text(
          "Search".tr(),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xffF7F6FF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              // Navigator.pushReplacement(
              //     context,
              //     PageRouteBuilder(
              //       pageBuilder: (context, animation, secondaryAnimation) =>
              //           const MainPage(),
              //       transitionsBuilder:
              //           (context, animation, secondaryAnimation, child) {
              //         const begin = Offset(-1.0, 0.0);
              //         const end = Offset.zero;
              //         const curve = Curves.easeInOut;
              //         var tween = Tween(begin: begin, end: end)
              //             .chain(CurveTween(curve: curve));
              //         var offsetAnimation = animation.drive(tween);

              //         return SlideTransition(
              //           position: offsetAnimation,
              //           child: child,
              //         );

              //       },
              //     ));
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xff6589FF),
            )),
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              width: 325,
              child: TextField(
                onChanged: (value) {
                  searchData = MySearchController().fetchSearchData(value,
                      end: widget.endDate != null
                          ? widget.endDate.toString()
                          : "",
                      start: widget.startDate != null
                          ? widget.startDate.toString()
                          : "",
                      status_id: widget.statuId != null
                          ? widget.statuId.toString()
                          : "");
                  setState(() {});
                },
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 24.0,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      searchController.clear();
                      setState(() {});
                    },
                    child: Container(
                        margin: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                            color: Color(0xffAFAFAF), shape: BoxShape.circle),
                        child: const Icon(
                          Icons.clear,
                          color: Color(0xffE6E6E6),
                          size: 20,
                        )),
                  ),
                  fillColor: const Color(0xffE6E6E6),
                  hintText: "Search".tr(),
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
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      clipBehavior: Clip.hardEdge,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return FilterBottomSheet(
                          textSearch: searchController.text,
                        );
                      });
                },
                icon: const Icon(
                  Icons.filter_alt_outlined,
                  size: 25,
                  color: Color(0xff6589FF),
                ))
          ],
        ),
        Expanded(
            child: searchController.text.isNotEmpty
                ? FutureBuilder(
                    future: searchData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.mails!.isNotEmpty
                            ? ListView.builder(
                                itemCount: snapshot.data!.mails?.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return myCustomCard(
                                      snapshot.data!.mails![index], () {
                                    showModalBottomSheet(
                                      clipBehavior: Clip.hardEdge,
                                      isScrollControlled: true,
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15.0),
                                      )),
                                      builder: (BuildContext context) {
                                        return EditMailBottomSheet(
                                          mail: snapshot.data!.mails![index],
                                        );
                                      },
                                    ).whenComplete(
                                      () {
                                        setState(() {
                                          Provider.of<NewInboxProvider>(context,
                                                  listen: false)
                                              .clearImages();

                                          Provider.of<NewInboxProvider>(context,
                                                  listen: false)
                                              .activites = [];

                                          Provider.of<NewInboxProvider>(context,
                                                  listen: false)
                                              .deletedImages = [];
                                        });
                                      },
                                    );

                                    ;
                                  });
                                  // return GestureDetector(
                                  //   onTap: () {},
                                  //   child: Container(
                                  //     margin: const EdgeInsets.symmetric(
                                  //         horizontal: 16, vertical: 8),
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 8, vertical: 16),
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(16),
                                  //       color: boxColor,
                                  //     ),
                                  //     child: Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.start,
                                  //           children: [
                                  //             Container(
                                  //               margin: const EdgeInsets.only(
                                  //                   right: 8),
                                  //               width: 12,
                                  //               height: 12,
                                  //               decoration: BoxDecoration(
                                  //                   borderRadius: BorderRadius
                                  //                       .circular(6),
                                  //                   color: snapshot
                                  //                               .data!
                                  //                               .mails![index]
                                  //                               .status !=
                                  //                           null
                                  //                       ? Color(int.parse(
                                  //                           snapshot
                                  //                                   .data!
                                  //                                   .mails![
                                  //                                       index]
                                  //                                   .status!
                                  //                                   .color ??
                                  //                               ""))
                                  //                       : Colors.white),
                                  //             ),
                                  //             if (snapshot.data!.mails?[index]
                                  //                     .sender !=
                                  //                 null)
                                  //               Text(snapshot
                                  //                       .data!
                                  //                       .mails?[index]
                                  //                       .sender!
                                  //                       .name ??
                                  //                   "no data"),
                                  //             const Spacer(),
                                  //             Text(getMonth(snapshot
                                  //                     .data!
                                  //                     .mails?[index]
                                  //                     .createdAt ??
                                  //                 "")),
                                  //             const Icon(
                                  //               Icons.arrow_forward_ios,
                                  //               color: Colors.grey,
                                  //             )
                                  //           ],
                                  //         ),
                                  //         Padding(
                                  //           padding: const EdgeInsets.symmetric(
                                  //               horizontal: 24.0),
                                  //           child: Column(
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //             children: [
                                  //               Text(snapshot
                                  //                       .data!
                                  //                       .mails?[index]
                                  //                       .subject ??
                                  //                   "no data"),
                                  //               Text(
                                  //                 snapshot.data!.mails?[index]
                                  //                         .description ??
                                  //                     "no data",
                                  //                 maxLines: 2,
                                  //                 overflow:
                                  //                     TextOverflow.ellipsis,
                                  //               ),
                                  //               const SizedBox(
                                  //                 height: 8,
                                  //               ),
                                  //               Text(
                                  //                 getTag(
                                  //                   snapshot.data!.mails![index]
                                  //                       .tags,
                                  //                 ),
                                  //                 style: const TextStyle(
                                  //                     color: Color(0xff6589FF)),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // );
                                })
                            : Center(
                                child: Text(
                                    "There are no emails on this data (${searchController.text})"),
                              );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      return const Center(
                        child: SpinKitPulse(
                          duration: Duration(milliseconds: 1000),
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    })
                : const Center()),
      ]),
    );
  }
}
