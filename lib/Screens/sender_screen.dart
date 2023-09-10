import 'dart:convert';

import 'package:final_projectt/core/services/new_inbox_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/senders_bottom_sheet.dart';
import 'package:final_projectt/models/catego_model.dart';
import 'package:final_projectt/models/sender_model.dart';
import 'package:flutter/material.dart';

class SendersScreen extends StatefulWidget {
  const SendersScreen({super.key});

  @override
  State<SendersScreen> createState() => _SendersScreenState();
}

class _SendersScreenState extends State<SendersScreen> {
  TextEditingController searchTextField = TextEditingController();
  late Future<Senders> senders;
  late Map<String, List<String>> searchMap = {};

  Future<void> initializeData() async {
    senders = getSenders();
    final sendersData = (await senders)
        .data
        .map<List<String>>(
            (sender) => [sender.id.toString(), sender.name, sender.mobile])
        .toList();

    for (int i = 0; i < sendersData.length; i++) {
      searchMap[sendersData[i][0]] = [sendersData[i][1], sendersData[i][2]];
    }
  }

  // searchSenders(String target) {
  //   List<MapEntry<String, List<String>>> matchingPairs = [];
  //   searchMap.forEach((key, valueList) {
  //     for (String stringValue in valueList) {
  //       if (stringValue.contains(target)) {
  //         matchingPairs.add(MapEntry(key, valueList));
  //         break;
  //       }
  //     }
  //   });

  //   for (MapEntry<String, List<String>> entry in matchingPairs) {
  //     print("Key: ${entry.key}, Value: ${entry.value}");
  //   }
  // }

  void searchSenders() {
    // Define the map
    Map<int, List<String>> data = {
      80: ["reema", "04562"],
      44: ["YazanCS", "0538844"],
      // ... (other key-value pairs)
      5: ["Tyreek Hudson", "(617) 819-4825"]
    };

    // Substring to search for
    String substring = "059";

    // Initialize a list to store matching key-value pairs
    List<MapEntry<int, List<String>>> matchingPairs = [];

    // Iterate through the map
    data.forEach((key, valueList) {
      for (String stringValue in valueList) {
        if (stringValue.contains(substring)) {
          matchingPairs.add(MapEntry(key, valueList));
          break; // Stop searching within this value list once a match is found
        }
      }
    });

    // Print the matching key-value pairs
    for (MapEntry<int, List<String>> entry in matchingPairs) {
      print("Key: ${entry.key}, Value: ${entry.value}");
    }
  }

  @override
  void initState() {
    super.initState();
    searchSenders();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 15,
            end: 15,
            top: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 270,
                    child: TextField(
                      controller: searchTextField,
                      // onChanged: (value) {
                      //    searchSenders(sendersData, searchTextField.text);
                      // },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        suffixIcon: IconButton(
                          onPressed: () {
                            searchTextField.clear();
                          },
                          icon: Icon(Icons.cancel),
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.05),
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Search ...",
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 19),
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
                  SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'cancel',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 23,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 10.0),
                  child: FutureBuilder(
                    future: senders,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else if (!snapshot.hasData) {
                        return Center(
                          child: Text('No data available.'),
                        );
                      }

                      dynamic sendersData = snapshot.data as Senders;
                      final categorizedSenders = categorizeSenders(sendersData);

                      return ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                        physics: BouncingScrollPhysics(),
                        itemCount: categorizedSenders.length,
                        itemBuilder: (context, sectionIndex) {
                          final category =
                              categorizedSenders.keys.elementAt(sectionIndex);
                          final categorySenders = categorizedSenders[category]!;
                          return Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                      top: 20.0,
                                      start: 5,
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  )
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: categorySenders.length,
                                itemBuilder: (context, itemIndex) {
                                  final sender = categorySenders[itemIndex];

                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        // Navigator.pop(context, sender);
                                      });
                                    },
                                    leading: Icon(Icons.person_3_outlined),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          sender.name,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              sender.mobile,
                                              style: TextStyle(fontSize: 17),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
