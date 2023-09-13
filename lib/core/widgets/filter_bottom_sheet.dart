import 'package:final_projectt/Screens/search_screen.dart';
import 'package:final_projectt/core/services/status_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_expansion.dart';
import 'package:final_projectt/models/status_model.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

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
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text("Cancel",
                      style: TextStyle(color: Color(0xff6589FF), fontSize: 18)),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchScreen()));
                  },
                ),
                const Text("Filter",
                    style: TextStyle(color: Color(0xff272727), fontSize: 18)),
                TextButton(
                  child: const Text("Done",
                      style: TextStyle(color: Color(0xff6589FF), fontSize: 18)),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen(
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
                  child: const Text("clear",
                      style:
                          TextStyle(color: Color(0xff6589FF), fontSize: 18))),
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
                                        snapshot.data!.statuses![index].name!,
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
              titleOfDate: " Start Data",
              children: <Widget>[
                CalendarDatePicker(
                  initialDate: DateTime(2023, 1, 1),
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
              titleOfDate: " End Data",
              children: <Widget>[
                CalendarDatePicker(
                  initialDate: DateTime.now(),
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
