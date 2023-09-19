import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/Screens/search_screen.dart';
import 'package:final_projectt/core/services/status_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_expansion.dart';
import 'package:final_projectt/models/status_model.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? textSearch;
  const FilterBottomSheet({super.key, this.textSearch});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int? selectedIndexStatus;
  late Future<StatusesesModel> statuses;
  DateTime? dateStart;
  DateTime? dateEnd;

  @override
  void initState() {
    statuses = StatusController().fetchStatuse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: MediaQuery.of(context).size.height * 0.95,
      color: const Color(0xffF7F6FF),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text("Cancel".tr(),
                      style: const TextStyle(
                          color: Color(0xff6589FF), fontSize: 18)),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchScreen()));
                  },
                ),
                Text("Filter".tr(),
                    style: const TextStyle(
                        color: Color(0xff272727), fontSize: 18)),
                TextButton(
                  child: Text("Done".tr(),
                      style: const TextStyle(
                          color: Color(0xff6589FF), fontSize: 18)),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen(
                                text: widget.textSearch,
                                statuId: selectedIndexStatus != null
                                    ? selectedIndexStatus! + 1
                                    : null,
                                startDate: dateStart,
                                endDate: dateEnd)));
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 24),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedIndexStatus = null;
                    });
                  },
                  child: Text("Clear".tr(),
                      style: const TextStyle(
                          color: Color(0xff6589FF), fontSize: 18))),
            ),
            FutureBuilder(
              future: statuses,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(32)),
                    width: 378,
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            String hexColor =
                                snapshot.data!.statuses![index].color!;

                            return ListTile(
                              onTap: () {
                                setState(() {
                                  selectedIndexStatus = index;
                                });
                              },
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                end: 12),
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color(int.parse(hexColor)),
                                        ),
                                      ),
                                      Text(
                                        "${snapshot.data!.statuses![index].name!}"
                                            .tr(),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const Spacer(),
                                      selectedIndexStatus == index
                                          ? Icon(
                                              Icons.check,
                                              color: primaryColor,
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        width: 15,
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 1,
                                    color:
                                        snapshot.data!.statuses!.length - 1 ==
                                                index
                                            ? Colors.transparent
                                            : Colors.grey.shade300,
                                  )
                                ],
                              ),
                            );
                          },
                          itemCount: 4,
                        )
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              },
            ),
            CustomExpansion(
              dateText: dateStart,
              titleOfDate: "Start Date".tr(),
              children: <Widget>[
                CalendarDatePicker(
                  currentDate: DateTime.now(),
                  initialDate: dateStart != null ? dateStart! : DateTime.now(),
                  firstDate: DateTime(1900, 1, 1),
                  lastDate: DateTime(2100, 1, 1),
                  onDateChanged: (DateTime newdate) {
                    setState(() {
                      dateStart = newdate;
                    });
                  },
                ),
              ],
            ),
            CustomExpansion(
              dateText: dateEnd,
              titleOfDate: "End Date".tr(),
              children: <Widget>[
                CalendarDatePicker(
                  currentDate: DateTime.now(),
                  initialDate: dateEnd != null ? dateEnd! : DateTime.now(),
                  firstDate: DateTime(1900, 1, 1),
                  lastDate: DateTime(2100, 1, 1),
                  onDateChanged: (DateTime newdate) {
                    setState(() {
                      dateEnd = newdate;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
