import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/services/change_roal_controller.dart';
import 'package:final_projectt/core/services/delet_user.dart';

import 'package:final_projectt/core/services/profile_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/show_alert.dart';

import 'package:final_projectt/models/all_user_model.dart';
import 'package:final_projectt/providers/all_user_provider.dart';
import 'package:final_projectt/providers/user_role_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CustomAlertDialog extends StatefulWidget {
  final String name;
  final String email;
  final String? image;
  final String role;
  final int userId;
  final int roleId;
  final String type;

  const CustomAlertDialog({
    super.key,
    required this.name,
    required this.email,
    required this.image,
    required this.role,
    required this.userId,
    required this.roleId,
    required this.type,
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  int _value = 0;
  ChangeRoleCotroller changeRoleCotroller = ChangeRoleCotroller();
  DeleteUserCotroller deleteUserCotroller = DeleteUserCotroller();
  @override
  void initState() {
    _value = widget.roleId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        actionsPadding: EdgeInsets.only(top: 15),
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.only(left: 20, right: 16, top: 15),
        title: Container(
          padding: const EdgeInsets.all(23),
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  widget.type == "edit"
                      ? "Change User Role".tr()
                      : "Delete User".tr(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              // Container(
              //   height: 100,
              //   width: 100,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(50),
              //       image: DecorationImage(
              //         image: widget.image != null
              //             ? NetworkImage(
              //                 'https://palmail.gsgtt.tech/storage/${widget.image}',

              //                 ,
              //               )
              //             : const AssetImage('images/profile.png')
              //                 as ImageProvider<Object>,
              //       )),
              // ),
              CircleAvatar(
                radius: 50,
                backgroundImage: widget.image != null
                    ? NetworkImage(
                        'https://palmail.gsgtt.tech/storage/${widget.image}',
                      )
                    : AssetImage('images/profile.png') as ImageProvider<Object>,
              )
            ],
          ),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Name :  ".tr(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: widget.name,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),
                  ]),
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Email :  ".tr(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),
                  ]),
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Role :  ".tr(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    TextSpan(
                        text: widget.role.tr(),
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),
                  ]),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.type == "edit"
                      ? "Attention: You are about to change the role of this user"
                          .tr()
                      : "Attention: You are about to delete of this user".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            widget.type == "edit"
                ? Consumer<UserRoleProvider>(
                    builder: (_, userRoleProvider, __) {
                      if (userRoleProvider.userRoledata.status ==
                          Status.LOADING) {
                        return const Center(
                          child: SpinKitPulse(
                            duration: Duration(milliseconds: 1000),
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      }

                      if (userRoleProvider.userRoledata.status ==
                          Status.COMPLETED) {
                        return Wrap(
                          spacing: 5.0,
                          children: List<Widget>.generate(
                            userRoleProvider.userRoledata.data!.roles!.length,
                            (int index) {
                              return ChoiceChip(
                                backgroundColor: Colors.black26,
                                selectedColor: Colors.blue,
                                label: Text(
                                  userRoleProvider
                                      .userRoledata.data!.roles![index].name!
                                      .tr(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                selected: _value == index + 1,
                                onSelected: (bool selected) {
                                  setState(() {
                                    _value = (selected ? index + 1 : null)!;
                                  });
                                },
                              );
                            },
                          ).toList(),
                        );
                      }

                      return const Text(" no data fron User role provider");
                    },
                  )
                : const SizedBox(),
          ],
        ),
        actions: <Widget>[
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 7,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    flex: 7,
                    child: TextButton(
                      onPressed: widget.type == "edit"
                          ? () async {
                              await changeRoleCotroller.changeRole(
                                  user_id: widget.userId, role_id: _value);

                              // ignore: use_build_context_synchronously
                              await Provider.of<AllUserProvider>(context,
                                      listen: false)
                                  .getusersData();

                              // ignore: use_build_context_synchronously
                              User? myinfo = Provider.of<AllUserProvider>(
                                      context,
                                      listen: false)
                                  .allUserdata
                                  .data
                                  ?.users
                                  ?.firstWhere(
                                      (element) => element.id == widget.userId);

                              await updateRoleSharedPreferences(myinfo?.role);

                              // ignore: use_build_context_synchronously
                              showAlert(context,
                                  message:
                                      'The role was changed successfully'.tr(),
                                  color: primaryColor.withOpacity(0.8),
                                  width: 230);

                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          : () async {
                              await deleteUserCotroller.deleteUser(
                                  user_id: widget.userId, name: widget.name);
                              // ignore: use_build_context_synchronously
                              await Provider.of<AllUserProvider>(context,
                                      listen: false)
                                  .getusersData();

                              // ignore: use_build_context_synchronously
                              showAlert(context,
                                  message:
                                      'The user was deleted successfully'.tr(),
                                  color: primaryColor.withOpacity(0.8),
                                  width: 230);

                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                      child: Text(
                        "Confirm".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          //   TextButton(
          //       onPressed: widget.type == "edit"
          //           ? () async {
          //               await changeRoleCotroller.changeRole(
          //                   user_id: widget.userId, role_id: _value);

          //               // ignore: use_build_context_synchronously
          //               await Provider.of<AllUserProvider>(context, listen: false)
          //                   .getusersData();

          //               // ignore: use_build_context_synchronously
          //               User? myinfo = Provider.of<AllUserProvider>(context,
          //                       listen: false)
          //                   .allUserdata
          //                   .data
          //                   ?.users
          //                   ?.firstWhere((element) => element.id == widget.userId);

          //               await updateRoleSharedPreferences(myinfo?.role);

          //               // ignore: use_build_context_synchronously
          //               showAlert(context,
          //                   message: 'The role was changed successfully'.tr(),
          //                   color: primaryColor.withOpacity(0.8),
          //                   width: 230);

          //               // ignore: use_build_context_synchronously
          //               Navigator.pop(context);
          //             }
          //           : () async {
          //               await deleteUserCotroller.deleteUser(
          //                   user_id: widget.userId, name: widget.name);
          //               // ignore: use_build_context_synchronously
          //               await Provider.of<AllUserProvider>(context, listen: false)
          //                   .getusersData();

          //               // ignore: use_build_context_synchronously
          //               showAlert(context,
          //                   message: 'The user was deleted successfully'.tr(),
          //                   color: primaryColor.withOpacity(0.8),
          //                   width: 230);

          //               // ignore: use_build_context_synchronously
          //               Navigator.pop(context);
          //             },
          //       child: Text(
          //         "Confirm".tr(),
          //         style: const TextStyle(fontSize: 16),
          //       )),
          //   TextButton(
          //       child: Text(
          //         'Cancel'.tr(),
          //         style: const TextStyle(fontSize: 16),
          //       ),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       }),
          // ],
        ]);
  }
}
