import 'package:easy_localization/easy_localization.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:final_projectt/core/services/new_inbox_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/models/tags_model.dart';

class TagsBottomSheet extends StatefulWidget {
  List<TagElement> givenTagsFromOutSide;
  TagsBottomSheet({
    Key? key,
    required this.givenTagsFromOutSide,
  }) : super(key: key);

  @override
  State<TagsBottomSheet> createState() => _TagsBottomSheetState();
}

class _TagsBottomSheetState extends State<TagsBottomSheet> {
  Future<Tag>? tags;
  TextEditingController addTagFieldController = TextEditingController();
  int greyIndex = 0;
  List<TagElement> selectedTags = [];

  @override
  void initState() {
    tags = getTags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedTags = widget.givenTagsFromOutSide;

    return SizedBox(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              top: 15.0,
              start: 8,
              end: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    // print(selectedTags);
                    Navigator.pop(context, selectedTags);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: primaryColor,
                  ),
                ),
                Center(
                  child: Text(
                    'Tags'.tr(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: tags,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (!snapshot.hasData || snapshot.data!.tags.isEmpty) {
                return const Center(
                  child: Text('No data available.'),
                );
              }

              List<Widget> tagsListForWhiteBox = snapshot.data!.tags.map((tag) {
                List<String> givenNameOfTags =
                    widget.givenTagsFromOutSide.map((e) {
                  return e.name;
                }).toList();
                // print(givenNameOfTags);
                final tagText = tag.name;
                final textLength = tagText.length;
                final tagWidth = 40.0 + (textLength * 8.0);
                final isSelected = givenNameOfTags.contains(tag.name);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedTags.removeWhere(
                            (selectedTag) => selectedTag.name == tag.name);
                      } else {
                        selectedTags.add(tag);
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: tagWidth,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor.withOpacity(0.7)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '#$tagText',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }).toList();

              return CustomWhiteBox(
                  width: 378,
                  height: (snapshot.data!.tags.length / 3).ceil() * 53,
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 15.0, top: 15),
                    child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: tagsListForWhiteBox),
                  ));
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 40.0, end: 40.0, top: 10),
            child: TextField(
              controller: addTagFieldController,
              decoration: InputDecoration(
                filled: true,
                suffixIcon: GestureDetector(
                  onTap: () async {
                    await createTag(addTagFieldController.text);
                    // showAlert(context,
                    //     message: "Tag Created Successfully",
                    //     color: primaryColor.withOpacity(0.7),
                    //     width: 250);
                    setState(() {
                      tags = getTags();
                      addTagFieldController.clear();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/hashtag.png',
                          width: 30,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                fillColor: boxColor,
                contentPadding:
                    const EdgeInsetsDirectional.only(start: 15, top: 15),
                hintText: "Add new tag ...".tr(),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 19),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: backGroundColor),
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red)),
            margin: const EdgeInsets.all(30.0),
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'The unselected will searched \nand deleted if there is no mail \nhas the tag',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 17,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
