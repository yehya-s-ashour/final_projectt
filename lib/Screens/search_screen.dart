import 'dart:convert';

import 'package:final_projectt/core/services/search_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/models/search_model.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  MySearchController mySearchController = MySearchController();
  TextEditingController searchController = TextEditingController();
//bool isbress = false;
  Search? mail;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F6FF),
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(color: Colors.black),
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
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              width: 325,
              child: TextField(
                onChanged: (value) async {
                  mail = await mySearchController.fetchSearchData(value);
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
                  hintText: "Search",
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
                  // show
                },
                icon: const Icon(
                  Icons.filter_alt_outlined,
                  size: 32,
                  color: Color(0xff6589FF),
                ))
          ],
        ),
        Expanded(
            child: searchController.text.isNotEmpty
                ? mail!.mails!.isNotEmpty
                    ? ListView.builder(
                        itemCount: mail!.mails?.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: boxColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: Color(int.parse(mail
                                                    ?.mails![index]
                                                    .status!
                                                    .color ??
                                                ""))),
                                      ),
                                      if (mail!.mails?[index].sender != null)
                                        Text(mail!.mails?[index].sender!.name ??
                                            "no data"),
                                      const Spacer(),
                                      Text(getMonth(
                                          mail?.mails?[index].createdAt ?? "")),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(mail?.mails?[index].subject ??
                                            "no data"),
                                        Text(
                                          mail?.mails?[index].description ??
                                              "no data",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          getTag(
                                            mail?.mails![index].tags,
                                          ),
                                          style: const TextStyle(
                                              color: Color(0xff6589FF)),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                    : Center(
                        child: Text(
                            "There are no emails on this data (${searchController.text})"),
                      )
                : const Center(
                    // child: Icon(
                    //   Icons.search,
                    //   size: 30,
                    //   color: Colors.grey,
                    // ),
                    ))
      ]),
    );
  }
}
