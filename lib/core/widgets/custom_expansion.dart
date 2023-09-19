import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomExpansion extends StatefulWidget {
  final String titleOfDate;
  final List<Widget> children;
  final DateTime? dateText;

  const CustomExpansion(
      {super.key,
      required this.titleOfDate,
      required this.children,
      required this.dateText});

  @override
  State<CustomExpansion> createState() => _CustomExpansionState();
}

class _CustomExpansionState extends State<CustomExpansion> {
  bool isDatePickerOpenedEnd = false;

  bool isValidationShown = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: isDatePickerOpenedEnd ? 515.0 : (isValidationShown ? 165 : 100),
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        width: 378,
        height: 480,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xffFFFFFF)),
        child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                      trailing: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear,
                        width: isDatePickerOpenedEnd ? 35 : 20,
                        child: Center(
                          child: Icon(
                            !isDatePickerOpenedEnd
                                ? Icons.arrow_forward_ios_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: !isDatePickerOpenedEnd ? 22 : 38,
                            color: !isDatePickerOpenedEnd
                                ? Colors.grey
                                : primaryColor,
                          ),
                        ),
                      ),
                      onExpansionChanged: (value) {
                        setState(() {
                          isDatePickerOpenedEnd = value;
                        });
                      },
                      textColor: const Color(0xff272727),
                      tilePadding: EdgeInsets.symmetric(horizontal: 22),
                      initiallyExpanded: false,
                      leading: const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.red,
                        size: 23,
                      ),
                      childrenPadding: EdgeInsets.zero,
                      title: SizedBox(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.titleOfDate,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Iphone',
                                  fontSize: 19),
                            ),
                            Text(
                              widget.dateText != null
                                  ? "${getDay(widget.dateText!)},${widget.dateText!.year},${getMonth(widget.dateText!)},${widget.dateText!.day}"
                                  : 'Sellect Your Date'.tr(),
                              //  '$todayName, $month $today, $year',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontFamily: 'Iphone',
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      //
                      children: widget.children),
                )
              ],
            )),
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
