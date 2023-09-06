import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/categories_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/custum_textfield.dart';
import 'package:final_projectt/core/widgets/date_picker.dart';
import 'package:final_projectt/core/widgets/senders_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/status_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/tags_bottom_sheet.dart';
import 'package:flutter/material.dart';

void newInboxButtonSheet(BuildContext context, Function callback) {
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 55,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const Text(
                          'New Inbox',
                          style:
                              TextStyle(fontSize: 20, color: Color(0xFF272727)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Done',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    child: Column(
                      children: [
                        CustomWhiteBox(
                          width: 378,
                          height: 175,
                          child: Column(
                            children: [
                              CustomTextField(
                                validationMessage: "Please enter a sender name",
                                hintText: "Sender",
                                hintTextColor: Colors.grey,
                                isPrefixIcon: true,
                                isSuffixIcon: true,
                                isUnderlinedBorder: true,
                                prefixIcon: Icon(
                                  Icons.person_3_outlined,
                                  size: 23,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    SendersBottomSheet(context);
                                  },
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Color(0xff6589FF),
                                    size: 27,
                                  ),
                                ),
                              ),
                              CustomTextField(
                                validationMessage:
                                    "Please enter a mobile number",
                                hintText: "Mobile",
                                hintTextColor: Colors.grey,
                                isPrefixIcon: true,
                                isSuffixIcon: false,
                                isUnderlinedBorder: true,
                                prefixIcon: Icon(
                                  Icons.phone_android_rounded,
                                  size: 23,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    SendersBottomSheet(context);
                                  },
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Color(0xff6589FF),
                                    size: 27,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  categoriesBottomSheet(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    start: 30.0,
                                    end: 20.0,
                                    top: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Category',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Iphone',
                                            fontSize: 22),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'other',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.grey,
                                            size: 22,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        CustomWhiteBox(
                          width: 378,
                          height: 120,
                          child: Column(
                            children: [
                              CustomTextField(
                                validationMessage:
                                    "Please enter a title of mail",
                                hintText: "Title of mail",
                                hintTextColor: Colors.grey,
                                isPrefixIcon: false,
                                isSuffixIcon: false,
                                isUnderlinedBorder: true,
                              ),
                              CustomTextField(
                                validationMessage: "Please enter a description",
                                hintText: "Description",
                                hintTextColor: Colors.grey,
                                isPrefixIcon: false,
                                isSuffixIcon: false,
                                isUnderlinedBorder: false,
                              ),
                            ],
                          ),
                        ),
                        CustomDatePicker(),
                        GestureDetector(
                          onTap: () {
                            tagssBottomSheet(context);
                          },
                          child: CustomWhiteBox(
                            width: 387,
                            height: 56,
                            child: const Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 20.0,
                                end: 20.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.tag,
                                        size: 23,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        'Tags',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Iphone',
                                            fontSize: 22),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            statusBottomSheet(context);
                          },
                          child: CustomWhiteBox(
                            width: 387,
                            height: 56,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 20.0,
                                end: 20.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.tag),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        height: 32,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              alignment: Alignment.center,
                                              width: 75,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Text(
                                                'Inbox',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            );
                                          },
                                          itemCount: 2,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                              width: 10,
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        CustomWhiteBox(
                          width: 378,
                          height: 105,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsetsDirectional.only(
                                  start: 25.0,
                                  end: 20.0,
                                  top: 20.0,
                                ),
                                child: Text(
                                  'Descision',
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              CustomTextField(
                                  validationMessage: 'Please enter a decision',
                                  hintText: 'Add Decision ...',
                                  hintTextColor: Colors.grey,
                                  isPrefixIcon: false,
                                  isSuffixIcon: false,
                                  isUnderlinedBorder: false)
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: CustomWhiteBox(
                            width: 387,
                            height: 56,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 20.0,
                                end: 20.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        color: Colors.blueGrey,
                                        size: 23,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        'Add image',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontFamily: 'Iphone',
                                            fontSize: 22),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: const ExpansionTile(
                            textColor: Color(0xff272727),
                            tilePadding: EdgeInsets.symmetric(horizontal: 30),
                            initiallyExpanded: false,
                            title: Text(
                              'Activity',
                              style: TextStyle(
                                fontSize: 23,
                              ),
                            ),
                            children: <Widget>[],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 20.0, end: 20.0, bottom: 20),
                          child: TextField(
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.send,
                                    color: primaryColor,
                                  )),
                              //should be replaced with profie image
                              prefixIcon: Icon(Icons.person),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.05),
                              contentPadding: EdgeInsets.all(15),
                              hintText: "Add new activity ...",
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 19),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  ).whenComplete(
    () {
      callback();
    },
  );
}
