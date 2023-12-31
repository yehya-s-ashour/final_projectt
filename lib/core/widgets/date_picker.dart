import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/my_expansion_tile.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDatePicker extends StatefulWidget {
  final bool? isLined;
  CustomDatePicker({this.isLined = true});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker>
    with SingleTickerProviderStateMixin {
  DateTime date = DateTime.now();
  // late AnimationController _animationController;
  // static final Animatable<double> _easeInTween =
  //     CurveTween(curve: Curves.easeIn);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int year = date.year;
    int today = date.day;
    dynamic month = getMonth(date);
    dynamic todayName = getDay(date);
    dynamic todayNameInAr = getDayInAr(date);
    dynamic monthInAr = getMonthInAr(date);

    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: MYExpansionTile(
            // trailing: RotationTransition(
            //   turns: _animationController.drive(
            //     Tween<double>(
            //       begin: -0.25,
            //       end: 0.0,
            //     ).chain(_easeInTween),
            //   ),
            //   child: const Icon(
            //     Icons.expand_more,
            //     size: 30,
            //   ),
            // ),
            onExpansionChanged: (value) {
              setState(() {
                // if (value) {
                //   _animationController.forward();
                // } else {
                //   _animationController.reverse();
                // }
                Provider.of<NewInboxProvider>(context, listen: false)
                    .setIsDatePickerOpened(value);
              });
            },
            textColor: const Color(0xff272727),
            tilePadding: const EdgeInsets.symmetric(horizontal: 22),
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
                    'Date'.tr(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Iphone',
                        fontSize: 18),
                  ),
                  Text(
                    context.locale.toString() == 'en'
                        ? '$todayName, $month $today, $year'
                        : '$todayNameInAr,$today $monthInAr , $year',
                    style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'Iphone',
                        fontSize: 15),
                  ),
                ],
              ),
            ),
            children: <Widget>[
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: CalendarDatePicker(
                    initialDate: date,
                    firstDate: DateTime(1900, 1, 1),
                    lastDate: DateTime(2100, 1, 1),
                    onDateChanged: (DateTime newdate) {
                      setState(() {
                        date = newdate;
                        Provider.of<NewInboxProvider>(context, listen: false)
                            .setDate(newdate);
                      });
                    },
                  )
                  // Hidden when not expanded
                  ),
            ],
          ),
        ),
        widget.isLined!
            ? Container(
                margin: const EdgeInsetsDirectional.only(start: 10, end: 10),
                width: MediaQuery.sizeOf(context).width,
                height: 1,
                color: Colors.grey.shade300,
              )
            : const SizedBox(),
      ],
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

getDayInAr(DateTime date) {
  dynamic dayData =
      '{ "1" : "الاثنين", "2" : "الثلاثاء", "3" : "الاربعاء", "4" : "الخميس", "5" : "الجمعة", "6" : "السبت", "7" : "الاحد" }';
  return json.decode(dayData)['${date.weekday}'];
}

getMonthInAr(DateTime date) {
  dynamic monthData =
      '{ "1" : "يناير", "2" : "فبراير", "3" : "مارس", "4" : "ابريل", "5" : "مايو", "6" : "يونيو", "7" : "يوليو", "8" : "اغسطس", "9" : "سبتمبر", "10" : "اكتوبر", "11" : "نوفمبر", "12" : "ديسمبر" }';
  return json.decode(monthData)['${date.month}'];
}
