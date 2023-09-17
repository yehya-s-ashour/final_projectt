import 'package:final_projectt/Screens/main_screen.dart';
import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/util/constants/colors.dart';

import 'package:final_projectt/core/widgets/custom_alert.dart';
import 'package:final_projectt/providers/all_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "User Management",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const MainPage();
            }));
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.blueAccent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Consumer<AllUserProvider>(
          builder: (_, allUserProvider, __) {
            if (allUserProvider.allUserdata.status == Status.LOADING) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (allUserProvider.allUserdata.status == Status.COMPLETED) {
              return ListView.builder(
                  itemCount: allUserProvider.allUserdata.data?.users?.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                child: allUserProvider.allUserdata.data!
                                            .users![index].image !=
                                        null
                                    ? Image.network(
                                        'https://palmail.gsgtt.tech/storage/${allUserProvider.allUserdata.data!.users![index].image!}',
                                        fit: BoxFit.fill,
                                      )
                                    : Image.asset('images/user.jpg'),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    allUserProvider
                                        .allUserdata.data!.users![index].name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  allUserProvider.allUserdata.data!
                                              .users![index].role !=
                                          null
                                      ? Text(
                                          allUserProvider.allUserdata.data!
                                              .users![index].role!.name!,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomAlertDialog(
                                          name: allUserProvider.allUserdata
                                              .data!.users![index].name!,
                                          email: allUserProvider.allUserdata
                                              .data!.users![index].email!,
                                          image: allUserProvider.allUserdata
                                              .data!.users![index].image,
                                          role: allUserProvider.allUserdata
                                              .data!.users![index].role!.name!,
                                          userId: allUserProvider.allUserdata
                                              .data!.users![index].id!,
                                          roleId: allUserProvider.allUserdata
                                              .data!.users![index].role!.id!,
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                          )
                        ],
                      ),
                    );
                  });
            }

            return Text(" no data from All User Provider ");
          },
        ),
      ),
    );
  }
}
