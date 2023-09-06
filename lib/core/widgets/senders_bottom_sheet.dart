import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';

void SendersBottomSheet(BuildContext context) {
  TextEditingController searchTextField = TextEditingController();
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
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded),
                          suffixIcon: IconButton(
                              onPressed: () {
                                searchTextField.clear();
                              },
                              icon: Icon(Icons.cancel)),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: 20.0,
                        start: 5,
                      ),
                      child: Text(
                        'Foreign',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.sizeOf(context).width,
                      height: 1,
                      color: Colors.grey.shade300,
                    )
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsetsDirectional.only(top: 20),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return const ListTile(
                        leading: Icon(Icons.person_3_outlined),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Sincer Rose',
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
                                  '+123456789',
                                  style: TextStyle(fontSize: 17),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: 10,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 20,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      });
    },
  );
}
