import 'package:final_projectt/core/services/user_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/date_picker.dart';
import 'package:final_projectt/models/user_model.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivitesExpansionTile extends StatefulWidget {
  const ActivitesExpansionTile({super.key});

  @override
  State<ActivitesExpansionTile> createState() => _ActivitesExpansionTileState();
}

class _ActivitesExpansionTileState extends State<ActivitesExpansionTile> {
  DateTime date = DateTime.now();
  late UserModel user;
  bool isActivitesOpened = false;

  getUser() async {
    user = await UserController().getLocalUser();
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              isActivitesOpened = !isActivitesOpened;
            });
          },
          trailing: SizedBox(
            width: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Provider.of<NewInboxProvider>(context).activites!.length == 0
                    ? SizedBox()
                    : Center(
                        child: Text(
                          '${Provider.of<NewInboxProvider>(context).activites!.length}',
                          style: TextStyle(
                              color: !isActivitesOpened
                                  ? Colors.grey
                                  : primaryColor,
                              fontSize: 17),
                        ),
                      ),
                SizedBox(
                  width: 7,
                ),
                Center(
                  child: Icon(
                    isActivitesOpened
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.keyboard_arrow_down_outlined,
                    size: isActivitesOpened ? 20 : 30,
                    color: !isActivitesOpened ? Colors.grey : primaryColor,
                  ),
                )
              ],
            ),
          ),
          textColor: Color(0xff272727),
          tilePadding: EdgeInsets.symmetric(horizontal: 30),
          initiallyExpanded: false,
          title: Text(
            'Activity',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount:
                  Provider.of<NewInboxProvider>(context).activites!.length,
              itemBuilder: (context, index) {
                return CustomWhiteBox(
                  height: 85,
                  width: 378,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              CircleAvatar(radius: 12),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '${user.user.name}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Iphone',
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${Provider.of<NewInboxProvider>(context).activites![index]['body']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Iphone',
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.only(end: 20, top: 15),
                        child: Column(
                          children: [
                            Text(
                              '${date.day} ${getMonth(date)} ${date.year}',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 16),
                            ),
                            IconButton(
                                onPressed: () {
                                  Provider.of<NewInboxProvider>(context,
                                          listen: false)
                                      .activites!
                                      .removeAt(index);
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          ]),
    );
  }
}
