import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/services/user_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/date_picker.dart';
import 'package:final_projectt/models/user_model.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivitesExpansionTile extends StatefulWidget {
  @override
  State<ActivitesExpansionTile> createState() => _ActivitesExpansionTileState();
}

class _ActivitesExpansionTileState extends State<ActivitesExpansionTile>
    with SingleTickerProviderStateMixin {
  DateTime date = DateTime.now();
  late UserModel user;
  bool isActivitesOpened = false;
  late AnimationController _animationController;
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  getUser() async {
    user = await UserController().getLocalUser();
  }

  @override
  void initState() {
    getUser();
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              if (value) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
              isActivitesOpened = !isActivitesOpened;
            });
          },
          trailing: SizedBox(
            width: 65,
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
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: RotationTransition(
                    turns: _animationController.drive(
                      Tween<double>(
                        begin: -0.25,
                        end: 0.0,
                      ).chain(_easeInTween),
                    ),
                    child: const Icon(
                      Icons.expand_more,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          textColor: Color(0xff272727),
          tilePadding: EdgeInsets.symmetric(horizontal: 30),
          initiallyExpanded: false,
          title: Text(
            'Activity'.tr(),
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
                              CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(
                                    'https://palmail.gsgtt.tech/storage/${user.user.image}'),
                                backgroundColor: Colors.transparent,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '${user.user.name}',
                                style: TextStyle(
                                  fontSize: 18,
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
