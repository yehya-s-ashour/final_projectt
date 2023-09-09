import 'package:final_projectt/core/services/status_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/models/status_model.dart';
import 'package:flutter/material.dart';

class StatusesBottomSheet extends StatefulWidget {
  const StatusesBottomSheet({super.key});

  @override
  State<StatusesBottomSheet> createState() => _StatusesBottomSheetState();
}

class _StatusesBottomSheetState extends State<StatusesBottomSheet> {
  int selectedIndex = 0;
  late SingleStatus SelectedStatus = SingleStatus(
      id: 0,
      name: 'Inbox',
      color: '0xfffa3a57',
      createdAt: '',
      updatedAt: '',
      mailsCount: '');

  late Future<StatusesesModel> statuses;

  @override
  void initState() {
    statuses = StatusController().fetchStatuse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsetsDirectional.only(top: 15.0, start: 8, end: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, SelectedStatus);
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
                    fontSize: 20,
                  ),
                ),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: statuses,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              String hexColor =
                                  snapshot.data!.statuses![index].color!;

                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    SelectedStatus =
                                        snapshot.data!.statuses![index];
                                  });
                                },
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsetsDirectional.only(
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
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Spacer(),
                                        selectedIndex == index
                                            ? Icon(
                                                Icons.check,
                                                color: primaryColor,
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
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
                          ),
                        )
                      ],
                    ),
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
          )
        ],
      ),
    );
  }
}
