import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:flutter/material.dart';

void tagssBottomSheet(BuildContext context) {
  int itemCount = 4;
  showModalBottomSheet(
    clipBehavior: Clip.hardEdge,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
      top: Radius.circular(15.0),
    )),
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 150,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    top: 15.0, start: 8, end: 8),
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
              Padding(
                padding: EdgeInsetsDirectional.only(top: 5, start: 5, end: 5),
                child: Column(
                  children: [
                    CustomWhiteBox(
                      width: 378,
                      height: 102,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 15.0, end: 15.0, top: 15),
                        child: Wrap(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsetsDirectional.only(
                                bottom: 10,
                                end: 10,
                              ),
                              width: 75,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Inbox',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsetsDirectional.only(
                                bottom: 10,
                                end: 10,
                              ),
                              width: 75,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Inbox',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsetsDirectional.only(
                                bottom: 10,
                                end: 10,
                              ),
                              width: 75,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Inbox',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsetsDirectional.only(
                                bottom: 10,
                                end: 10,
                              ),
                              width: 75,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Inbox',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsetsDirectional.only(
                                bottom: 10,
                                end: 10,
                              ),
                              width: 75,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Inbox',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsetsDirectional.only(
                                bottom: 10,
                                end: 10,
                              ),
                              width: 75,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Inbox',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 20.0, end: 20.0, top: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: boxColor,
                          contentPadding: EdgeInsets.all(15),
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
              ),
            ],
          ),
        );
      });
    },
  );
}
