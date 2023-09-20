// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/services/tags_controller.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:flutter/material.dart';

import '../core/util/constants/colors.dart';
import '../models/mail_model.dart';
import '../models/tags_model.dart';

class TagsScreen extends StatefulWidget {
  List<TagElement> tagsList;
  TagsScreen({
    Key? key,
    required this.tagsList,
  }) : super(key: key);

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  late Future<List<Mail>> mails;
  List<int> allTagsIds = [];
  Set<int> tagsIdsToBeShown = {};
  int greyIndex = 0;
  bool isAllTagSelected = true;
  @override
  void initState() {
    mails = getAllMailsHaveTags(allTagsIds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String allTag = 'All Tags';

    List<Widget>? tagsListForWhiteBox;
    tagsListForWhiteBox = [
      GestureDetector(
        onTap: () {
          isAllTagSelected = !isAllTagSelected;
          setState(() {
            if (isAllTagSelected) {
              mails = getAllMailsHaveTags(allTagsIds);
            } else if (tagsIdsToBeShown.isEmpty) {
              mails = getAllMailsHaveTags([]);
            } else {
              mails = getAllMailsHaveTags(tagsIdsToBeShown.toList());
            }
          });
        },
        child: Container(
          alignment: Alignment.center,
          height: 32,
          width: 40.0 + (allTag.length * 7.0),
          decoration: BoxDecoration(
            color: isAllTagSelected
                ? primaryColor
                : const Color.fromARGB(255, 208, 207, 207),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'All Tags'.tr(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ),
      ...widget.tagsList.map((tag) {
        allTagsIds.add(tag.id);
        final tagText = tag.name;
        final textLength = tagText.length;
        final tagWidth = 40.0 + (textLength * 8.0);
        bool isSelected = tagsIdsToBeShown.contains(tag.id);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (tagsIdsToBeShown.contains(tag.id)) {
                tagsIdsToBeShown.remove(tag.id);
              } else {
                tagsIdsToBeShown.add(tag.id);
              }
              if (tagsIdsToBeShown.isNotEmpty && isAllTagSelected == false) {
                mails = getAllMailsHaveTags(tagsIdsToBeShown.toList());
              } else if (tagsIdsToBeShown.isEmpty &&
                  isAllTagSelected == false) {
                mails = getAllMailsHaveTags([]);
              } else {
                mails = getAllMailsHaveTags(allTagsIds);
              }
            });
          },
          child: Container(
            alignment: Alignment.center,
            width: tagWidth,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor
                  : const Color.fromARGB(255, 208, 207, 207),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '#$tagText',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    ];

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: Text(
          'Tags'.tr(),
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: backGroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomWhiteBox(
                width: double.infinity,
                height: (widget.tagsList.length / 3).ceil() * 46,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8.0, top: 8),
                  child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: tagsListForWhiteBox),
                )),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  ((widget.tagsList.length / 3).ceil() * 52),
              child: FutureBuilder(
                  future: mails,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return myCustomCard(
                              snapshot.data![index],
                              () {},
                            );
                          });
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
            ),
          ],
        ),
      ),
    );
  }
}
