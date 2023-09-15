import 'package:flutter/material.dart';
import 'package:final_projectt/core/services/new_inbox_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/models/sender_model.dart';

class SendersBottomSheet extends StatefulWidget {
  const SendersBottomSheet({super.key});

  @override
  State<SendersBottomSheet> createState() => _SendersBottomSheetState();
}

class _SendersBottomSheetState extends State<SendersBottomSheet> {
  TextEditingController searchTextField = TextEditingController();
  late Future<Senders> senders;
  late Map<String, SingleSender> searchMap = {};
  List<MapEntry<String, SingleSender>> matchingPairs = [];

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
    matchingPairs.clear();

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
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 25, start: 20, end: 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 150,
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
                    onChanged: (value) {
                      searchSenders(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            searchTextField.clear();
                          });
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
                            SizedBox(
                              height: 70,
                            )
                          ],
                        ),
                      );
                    }
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
                          return SizedBox.shrink(); // Hide the empty section
                        }

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
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        Navigator.pop(
                                            context,
                                            entry
                                                .value); // Use entry.value to access SingleSender
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
                                          entry.value.name!,
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
                                              entry.value.mobile!,
                                              style: TextStyle(fontSize: 17),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                } else if (sender != null) {
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        Navigator.pop(context, sender);
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
                                          sender.name!,
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
                                              sender.mobile!,
                                              style: TextStyle(fontSize: 17),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }
                                return SizedBox.shrink(); // Hide empty items
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
    );
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
