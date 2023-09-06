import 'dart:convert';

import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/custum_textfield.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime date = DateTime.now();
  bool isDatePickerOpened = false;

  @override
  Widget build(BuildContext context) {
    int year = date.year;
    int today = date.day;
    dynamic month = getMonth(date);
    dynamic todayName = getDay(date);

    return AnimatedContainer(
      height: isDatePickerOpened ? 480.0 : 135.0,
      duration: Duration(milliseconds: 300),
      child: CustomWhiteBox(
        width: 378,
        height: 480,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  onExpansionChanged: (value) {
                    setState(() {
                      isDatePickerOpened = value;
                    });
                  },
                  textColor: Color(0xff272727),
                  tilePadding: EdgeInsets.symmetric(horizontal: 22),
                  initiallyExpanded: false,
                  leading: Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.red,
                    size: 23,
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Iphone',
                            fontSize: 22),
                      ),
                      Text(
                        '$todayName, $month $today, $year',
                        style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'Iphone',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  //
                  children: <Widget>[
                    CalendarDatePicker(
                      initialDate: date,
                      firstDate: DateTime(2023, 1, 1),
                      lastDate: DateTime(2023, 12, 31),
                      onDateChanged: (DateTime newdate) {
                        setState(() {
                          date = newdate;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(start: 10, end: 10),
                width: MediaQuery.sizeOf(context).width,
                height: 1,
                color: Colors.grey.shade300,
              ),
              CustomTextField(
                validationMessage: "Please enter an archive number",
                hintText: "Archive number",
                hintTextColor: Colors.black,
                isPrefixIcon: true,
                isSuffixIcon: false,
                isUnderlinedBorder: false,
                prefixIcon: Icon(
                  Icons.folder_zip_outlined,
                  color: Colors.blueGrey,
                  size: 23,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

getDay(DateTime date) {
  dynamic dayData =
      '{ "1" : "Mon", "2" : "Tue", "3" : "Wed", "4" : "Thur", "5" : "Fri", "6" : "Sat", "7" : "Sun" }';
  return json.decode(dayData)['${date.weekday}'];
}

getMonth(DateTime date) {
  dynamic monthData =
      '{ "1" : "Jan", "2" : "Feb", "3" : "Mar", "4" : "Apr", "5" : "May", "6" : "June", "7" : "Jul", "8" : "Aug", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" }';
  return json.decode(monthData)['${date.month}'];
}
