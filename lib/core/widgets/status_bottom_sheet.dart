import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:flutter/material.dart';

void statusBottomSheet(BuildContext context) {
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
                    top: 15.0, start: 8, end: 20),
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
                    Text(
                      'Status',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                    Center(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 5, start: 5, end: 5),
                child: CustomWhiteBox(
                  width: 378,
                  height: 280,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: 15,
                          end: 10,
                          top: 5,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Add status',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.mode_edit_outlined,
                                      color: Colors.grey,
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsetsDirectional.only(end: 12),
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        'Sincer Rose',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 1,
                                    color: itemCount - 1 == index
                                        ? Colors.transparent
                                        : Colors.grey.shade300,
                                  )
                                ],
                              ),
                            );
                          },
                          itemCount: 4,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}
