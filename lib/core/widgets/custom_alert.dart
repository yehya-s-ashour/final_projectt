import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/services/change_roal_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/show_alert.dart';
import 'package:final_projectt/providers/all_user_provider.dart';
import 'package:final_projectt/providers/user_role_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAlertDialog extends StatefulWidget {
  final String name;
  final String email;
  final String? image;
  final String role;
  final int userId;
  final int roleId;

  const CustomAlertDialog({
    super.key,
    required this.name,
    required this.email,
    required this.image,
    required this.role,
    required this.userId,
    required this.roleId,
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  int _value = 0;
  ChangeRoleCotroller changeRoleCotroller = ChangeRoleCotroller();
  @override
  void initState() {
    _value = widget.roleId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      title: Container(
        padding: const EdgeInsets.all(23),
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(32), topLeft: Radius.circular(32)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Change User Rloe",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 100,
              width: 100,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: widget.image != null
                  ? Image.network(
                      'https://palmail.gsgtt.tech/storage/${widget.image}',
                      fit: BoxFit.fill,
                    )
                  : Image.asset('images/user.jpg'),
            ),
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
              const Text("user information"),
              const SizedBox(
                height: 8,
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: "Name :  ",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  TextSpan(
                      text: widget.name,
                      style: const TextStyle(
                          color: Colors.blueAccent, fontSize: 16)),
                ]),
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: "Email :  ",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                          color: Colors.blueAccent, fontSize: 16)),
                ]),
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: "Role :  ",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  TextSpan(
                      text: widget.role,
                      style: const TextStyle(
                          color: Colors.blueAccent, fontSize: 16)),
                ]),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                  "Attention: You are about to change the role of this user"),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Consumer<UserRoleProvider>(
            builder: (_, userRoleProvider, __) {
              if (userRoleProvider.userRoledata.status == Status.LOADING) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (userRoleProvider.userRoledata.status == Status.COMPLETED) {
                return Wrap(
                  spacing: 5.0,
                  children: List<Widget>.generate(
                    userRoleProvider.userRoledata.data!.roles!.length,
                    (int index) {
                      return ChoiceChip(
                        selectedColor: Colors.blueAccent,
                        label: Text(userRoleProvider
                            .userRoledata.data!.roles![index].name!),
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
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              await changeRoleCotroller.changeRole(
                  user_id: widget.userId, role_id: _value);

              Provider.of<AllUserProvider>(context, listen: false)
                  .UpdateAllUserProvider();

              showAlert(context,
                  message: 'The role was changed successfully',
                  color: primaryColor.withOpacity(0.8),
                  width: 230);

              Navigator.pop(context);
            },
            child: const Text(
              "confirm",
              style: TextStyle(fontSize: 16),
            )),
        TextButton(
            child: const Text(
              'cancel',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }
}
