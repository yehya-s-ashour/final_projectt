import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/services/status_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/models/status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StatusesBottomSheet extends StatefulWidget {
  StatusMod? status;
  StatusesBottomSheet({super.key, this.status});

  @override
  State<StatusesBottomSheet> createState() => _StatusesBottomSheetState();
}

class _StatusesBottomSheetState extends State<StatusesBottomSheet> {
  late int selectedIndex;

  late StatusMod SelectedStatus = StatusMod(
      id: 1,
      name: 'Inbox',
      color: '0xfffa3a57',
      createdAt: '',
      updatedAt: '',
      mailsCount: '');

  late Future<StatusesesModel> statuses;

  @override
  void initState() {
    statuses = StatusController().fetchStatuse();
    selectedIndex = widget.status!.id! - 1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
                top: 25.0, start: 8, end: 20, bottom: 10),
            child: Text(
              'Status'.tr(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          FutureBuilder(
            future: statuses,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsetsDirectional.only(
                      top: 5, start: 5, end: 5),
                  child: CustomWhiteBox(
                    width: 378,
                    height: 280,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
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
                                    'Add status'.tr(),
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
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
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              String hexColor =
                                  snapshot.data!.statuses![index].color!;

                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    SelectedStatus =
                                        snapshot.data!.statuses![index];
                                    Future.delayed(
                                        const Duration(milliseconds: 200), () {
                                      Navigator.pop(context, SelectedStatus);
                                    });
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
                                          snapshot.data!.statuses![index].name!
                                              .tr(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const Spacer(),
                                        selectedIndex == index
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
              return Column(
                children: [
                  SizedBox(
                    height: 250,
                  ),
                  SpinKitPulse(
                    duration: Duration(milliseconds: 1000),
                    color: Colors.grey,
                    size: 40,
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
