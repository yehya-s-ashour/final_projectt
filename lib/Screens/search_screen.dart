import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/services/search_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/edit_mail_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/filter_bottom_sheet.dart';
import 'package:final_projectt/models/search_model.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
//import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

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
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xff6589FF),
            )),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(children: [
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
                  autofocus: false,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                        });
                      },
                      icon: const Icon(Icons.cancel),
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
                                            backScreen: 'Search',
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


                                    ;
                                  });
                                })
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 200,
                                      child: Image.asset(
                                          "images/result_not_found.png")),
                                ],
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
      ),
    );
  }
}
