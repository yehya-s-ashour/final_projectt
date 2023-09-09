import 'package:final_projectt/core/services/new_inbox_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/models/tags_model.dart';
import 'package:flutter/material.dart';

class TagsBottomSheet extends StatefulWidget {
  const TagsBottomSheet({super.key});

  @override
  State<TagsBottomSheet> createState() => _TagsBottomSheetState();
}

class _TagsBottomSheetState extends State<TagsBottomSheet> {
  Future<Tag>? tags;
  TextEditingController addTagFieldController = TextEditingController();
  @override
  void initState() {
    tags = getTags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsetsDirectional.only(top: 15.0, start: 8, end: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: primaryColor,
                  ),
                ),
                Center(
                  child: Text(
                    'Tags',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
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
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text('No data available.'),
                );
              }
              return Padding(
                padding: EdgeInsetsDirectional.only(top: 5, start: 5, end: 5),
                child: Column(
                  children: [
                    CustomWhiteBox(
                      width: 378,
                      height: (snapshot.data!.tags.length / 3).round() * 52,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 15.0, top: 15),
                        child: Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: snapshot.data!.tags.map((tag) {
                            final tagText = tag.name;
                            final textLength = tagText.length;
                            final tagWidth = 20.0 + (textLength * 7.0);
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                width: tagWidth,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  tagText,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 20.0, end: 20.0, top: 10),
                      child: TextField(
                        controller: addTagFieldController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  createTag(addTagFieldController.text);
                                  tags = getTags();
                                });
                                addTagFieldController.clear();
                              },
                              icon: Icon(
                                Icons.send,
                                color: primaryColor,
                              )),
                          filled: true,
                          fillColor: boxColor,
                          contentPadding: EdgeInsetsDirectional.only(
                            start: 30,
                            top: 15,
                          ),
                          hintText: "Add new tag ...",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 19),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade200),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
