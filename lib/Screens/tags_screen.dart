// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:final_projectt/core/services/tags_controller.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:flutter/material.dart';

import '../core/util/constants/colors.dart';
import '../models/catego_model.dart';
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
  late Future<List<CategoryElement>> categories;
  late Future<List<Mails>> mails;
  late Future<List<TagElement>> tags;
  bool isAllTagSelected = true;
  bool isOtherTagSelected = false;
  List<int> allTagsIds = [];
  @override
  void initState() {
    // categories = getCatego();
    mails = getAllMailsHaveTags(allTagsIds);
    // tags = getAllTags();
    super.initState();
  }

  int greyIndex = 0;
  @override
  Widget build(BuildContext context) {
    String allTag = 'All Tags';
    List<Widget>? tagsListForWhiteBox;
    tagsListForWhiteBox = [
      GestureDetector(
        onTap: () {
          setState(() {
            greyIndex = 0;
            mails = getAllMailsHaveTags(allTagsIds);
          });
        },
        child: Container(
          alignment: Alignment.center,
          height: 32,
          width: 40.0 + (allTag.length * 7.0),
          decoration: BoxDecoration(
            color: greyIndex == 0
                ? const Color.fromARGB(255, 208, 207, 207)
                : primaryColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'All Tags',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ),
      ...widget.tagsList.map((tag) {
        final index = widget.tagsList.indexOf(tag) + 1;
        final tagText = tag.name;
        final textLength = tagText.length;
        allTagsIds.add(tag.id);
        final tagWidth = 40.0 + (textLength * 8.0);
        return GestureDetector(
          onTap: () {
            setState(() {
              greyIndex = index;
              mails = getAllMailsHaveTags([tag.id]);
            });
          },
          child: Container(
            alignment: Alignment.center,
            width: tagWidth,
            height: 32,
            decoration: BoxDecoration(
              color: index == greyIndex
                  ? const Color.fromARGB(255, 208, 207, 207)
                  : primaryColor,
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
        title: const Text(
          'Tags',
          style: TextStyle(
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
                width: 378,
                height: (widget.tagsList.length / 2).round() * 52,
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: 15.0, top: 15),
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
                  ((widget.tagsList.length / 2).round() * 52),
              child: FutureBuilder(
                  future: mails,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return myCustomCard(snapshot.data![index]);
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
