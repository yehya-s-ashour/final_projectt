import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/services/profile_controller.dart';
import 'package:final_projectt/core/services/user_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/show_alert.dart';
import 'package:final_projectt/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? pickedFile;
  String? filePath;
  bool isEditable = false;
  TextEditingController nameTextFieldCont = TextEditingController();
  late Future<UserModel> user;
  bool isUploading = false;
  String? name;
  @override
  void initState() {
    user = UserController().getLocalUser();
    user.then((userData) => {
          nameTextFieldCont.text = userData.user.name!,
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: pickedFile != null || isEditable
          ? FloatingActionButton(
              onPressed: () async {
                setState(() {
                  isUploading = true;
                });
                if (pickedFile != null) {
                  await uploadProfilePic(
                          pickedFile!, name ?? nameTextFieldCont.text)
                      .then((value) async {
                    final newImage = await getNewProfilePic();
                    updateSharedPreferences(
                            name ?? nameTextFieldCont.text, newImage!)
                        .then((value) {
                      setState(() {
                        isUploading = false;
                        user = UserController().getLocalUser();

                        showAlert(context,
                            message: "User Updated",
                            color: primaryColor.withOpacity(0.75),
                            width: 150);
                      });
                    });

                    if (mounted) {
                      setState(() {
                        isEditable = false;
                      });
                    }
                    if (mounted) {
                      setState(() {
                        pickedFile = null;
                      });
                    }
                    Provider.of<UserProvider>(context, listen: false)
                        .getUserData();
                  }).catchError((err) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(err.toString()),
                      backgroundColor: Colors.red,
                    ));
                  });
                } else {
                  updateName(name ?? nameTextFieldCont.text).then((value) {
                    updateNameSharedPreferences(name ?? nameTextFieldCont.text)
                        .then((value) {
                      setState(() {
                        isUploading = false;
                        showAlert(context,
                            message: "User Updated",
                            color: primaryColor.withOpacity(0.75),
                            width: 150);
                      });

                      if (mounted) {
                        setState(() {
                          isEditable = false;
                        });
                      }
                      if (mounted) {
                        setState(() {
                          pickedFile = null;
                        });
                      }
                      Provider.of<UserProvider>(context, listen: false)
                          .getUserData();
                    });
                  }).catchError((err) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(err.toString()),
                      backgroundColor: Colors.red,
                    ));
                  });
                }
              },
              backgroundColor: primaryColor,
              child: isUploading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check),
            )
          : null,
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: deviceWidth,
              height: deviceHeight * 0.4,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(170)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 38),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 200,
                    margin: const EdgeInsets.only(top: 115, left: 10),
                    child: Stack(
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'P',
                                style: TextStyle(
                                  fontSize: 110,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                          left: 40, // Adjust the left offset as needed
                          top: 72, // Adjust the top offset as needed
                          child: Text(
                            'rofile',
                            style: TextStyle(
                                letterSpacing: 3,
                                color: Colors.white,
                                fontSize: 35,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder(
                future: user,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    // print('the snapshot image : ${snapshot.data!.user.image}');
                    // path = snapshot.data!.user.image!;
                    return Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Stack(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 190, left: 180),
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundColor: Colors.blueGrey.shade300,
                                    child: Stack(
                                      children: [
                                        Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            child: Container(
                                              // margin: EdgeInsets.only(top: 3),
                                              height: 195,
                                              width: 195,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                            )),
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 98,
                                          backgroundImage: pickedFile == null
                                              ? NetworkImage(
                                                  'https://palmail.gsgtt.tech/storage/${snapshot.data!.user.image}',
                                                )
                                              : FileImage(
                                                  File(pickedFile!.path),
                                                ) as ImageProvider<Object>,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              pickedFile = await pickImageFile();

                              if (pickedFile != null) {
                                filePath = pickedFile!.path;
                              }
                              setState(() {});
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 15.0),
                              child: Container(
                                width: 45,
                                height: 45,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(25)),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }),
            FutureBuilder(
                future: user,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.only(top: 400, left: 30),
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.person),
                                ),
                                title: Text(
                                  'Name:'.tr(),
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 134, 134, 134),
                                      fontSize: 16),
                                ),
                                subtitle: isEditable
                                    ? TextField(
                                        controller: nameTextFieldCont,
                                        onChanged: (value) {
                                          setState(() {
                                            name = value;
                                          });
                                        },
                                        enabled: isEditable,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.only(bottom: 20),
                                          hintText:
                                              name ?? snapshot.data!.user.name,
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 20,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      )
                                    : Text(
                                        nameTextFieldCont.text,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                              ),
                            ),
                            IconButton(
                              padding:
                                  const EdgeInsets.only(right: 45, bottom: 0),
                              onPressed: () {
                                setState(() {
                                  isEditable = !isEditable;
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                color: primaryColor,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        ListTile(
                          leading: const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.email),
                          ),
                          title: Text(
                            'Email:'.tr(),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                          ),
                          subtitle: Text(
                            snapshot.data!.user.email!,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        ListTile(
                          leading: const CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Icons.account_box,
                            ),
                          ),
                          title: Text(
                            'Role:'.tr(),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                          ),
                          subtitle: Text(
                            snapshot.data!.user.role!.name!,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ]),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
