import 'dart:io';

import 'package:final_projectt/Screens/edit_profile.dart';
import 'package:final_projectt/core/services/user_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? pickedFile;
  late Future<UserModel> user;
  @override
  void initState() {
    user = UserController().getLocalUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 38),
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
                      FutureBuilder(
                          future: user,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            if (snapshot.hasData) {
                              return GestureDetector(
                                onTap: () async {
                                  final newPickedFile =
                                      await Navigator.push<File>(context,
                                          MaterialPageRoute(
                                    builder: (context) {
                                      return EditProfile(
                                        defaultName:
                                            snapshot.data!.user.name ?? 'name',
                                        defaultImagePath: pickedFile?.path ??
                                            snapshot.data!.user.image ??
                                            'image',
                                      );
                                    },
                                  ));

                                  if (newPickedFile != null) {
                                    setState(() {
                                      pickedFile = newPickedFile;
                                    });
                                  }
                                },
                                child: const Icon(Icons.edit_note,
                                    color: Colors.white),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 130, left: 20),
                    child: RichText(
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'P',
                            style: TextStyle(
                                fontSize: 100, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'rofile',
                            style: TextStyle(
                                fontSize: 30, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                    return Container(
                      margin: const EdgeInsets.only(top: 180, left: 180),
                      height: 200,
                      width: 200,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: pickedFile == null
                          ? Image.network(
                              'https://palmail.gsgtt.tech/storage/${snapshot.data!.user.image}',
                              fit: BoxFit.cover,
                            )
                          : Image.file(File(pickedFile!.path)),
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
                      margin: const EdgeInsets.only(top: 400),
                      child: Column(children: [
                        ListTile(
                          leading: const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person),
                          ),
                          title: const Text(
                            'Name:',
                            style: TextStyle(
                                color: Color.fromARGB(255, 134, 134, 134)),
                          ),
                          subtitle: Text(
                            snapshot.data!.user.name!,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        ListTile(
                          leading: const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.email),
                          ),
                          title: const Text(
                            'Email:',
                            style: TextStyle(
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
                            radius: 50,
                            child: Icon(
                              Icons.account_box,
                            ),
                          ),
                          title: const Text(
                            'Role:',
                            style: TextStyle(
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
