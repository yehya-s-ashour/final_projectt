import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/Screens/main_screen.dart';
import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/util/constants/colors.dart';

import 'package:final_projectt/core/widgets/custom_alert.dart';
import 'package:final_projectt/providers/all_user_provider.dart';
import 'package:final_projectt/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
        title: Text(
          "User Management".tr(),
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () async {
            await Provider.of<UserProvider>(context, listen: false)
                .getUserData();
            // ignore: use_build_context_synchronously
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
              return ListView.builder(
                itemCount: allUserProvider.allUserdata.data?.users?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      height: 70,
                    ),
                  );
                },
              );
            }
            if (allUserProvider.allUserdata.status == Status.COMPLETED) {
              return ListView.builder(
                  itemCount: allUserProvider.allUserdata.data?.users?.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Slidable(
                        endActionPane: ActionPane(
                          extentRatio: 0.4,
                          motion: const ScrollMotion(),
                          children: [
                            // const SizedBox(
                            //   width: 16,
                            // ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              width: 55,
                              height: 55,
                              child: SlidableAction(
                                padding: const EdgeInsets.all(0),
                                spacing: 3,
                                // An action can be bigger than the others.

                                borderRadius: BorderRadius.circular(16),

                                onPressed: (context) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomAlertDialog(
                                        type: "edit",
                                        name: allUserProvider.allUserdata.data!
                                            .users![index].name!,
                                        email: allUserProvider.allUserdata.data!
                                            .users![index].email!,
                                        image: allUserProvider.allUserdata.data!
                                            .users![index].image,
                                        role: allUserProvider.allUserdata.data!
                                            .users![index].role!.name!,
                                        userId: allUserProvider.allUserdata
                                            .data!.users![index].id!,
                                        roleId: allUserProvider.allUserdata
                                            .data!.users![index].role!.id!,
                                      );
                                    },
                                  );
                                },
                                backgroundColor: Colors.amberAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                //    label: 'Edit',
                              ),
                            ),
                            // const SizedBox(
                            //   width: 8,
                            // ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              width: 55,
                              height: 55,
                              child: SlidableAction(
                                borderRadius: BorderRadius.circular(16),
                                padding: const EdgeInsets.all(0),
                                spacing: 3,
                                onPressed: (context) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomAlertDialog(
                                        type: "delet",
                                        name: allUserProvider.allUserdata.data!
                                            .users![index].name!,
                                        email: allUserProvider.allUserdata.data!
                                            .users![index].email!,
                                        image: allUserProvider.allUserdata.data!
                                            .users![index].image,
                                        role: allUserProvider.allUserdata.data!
                                            .users![index].role!.name!,
                                        userId: allUserProvider.allUserdata
                                            .data!.users![index].id!,
                                        roleId: allUserProvider.allUserdata
                                            .data!.users![index].role!.id!,
                                      );
                                    },
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,

                                //  label: 'delete',
                              ),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? Colors.grey[100]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(16)),
                          child: Row(
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
                                    : Image.asset('images/profile.png'),
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
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }

            return const Text(" no data from All User Provider ");
          },
        ),
      ),
    );
  }
}















// const Spacer(),
                                // IconButton(
                                //     onPressed: () async {
                                //       showDialog(
                                //         context: context,
                                //         builder: (BuildContext context) {
                                //           return CustomAlertDialog(
                                //             type: "edit",
                                //             name: allUserProvider.allUserdata
                                //                 .data!.users![index].name!,
                                //             email: allUserProvider.allUserdata
                                //                 .data!.users![index].email!,
                                //             image: allUserProvider.allUserdata
                                //                 .data!.users![index].image,
                                //             role: allUserProvider.allUserdata
                                //                 .data!.users![index].role!.name!,
                                //             userId: allUserProvider.allUserdata
                                //                 .data!.users![index].id!,
                                //             roleId: allUserProvider.allUserdata
                                //                 .data!.users![index].role!.id!,
                                //           );
                                //         },
                                //       );
                                //     },
                                //     icon: const Icon(Icons.edit)),
                                // IconButton(
                                //     onPressed: () async {
                                //       showDialog(
                                //         context: context,
                                //         builder: (BuildContext context) {
                                //           return CustomAlertDialog(
                                //             type: "delet",
                                //             name: allUserProvider.allUserdata
                                //                 .data!.users![index].name!,
                                //             email: allUserProvider.allUserdata
                                //                 .data!.users![index].email!,
                                //             image: allUserProvider.allUserdata
                                //                 .data!.users![index].image,
                                //             role: allUserProvider.allUserdata
                                //                 .data!.users![index].role!.name!,
                                //             userId: allUserProvider.allUserdata
                                //                 .data!.users![index].id!,
                                //             roleId: allUserProvider.allUserdata
                                //                 .data!.users![index].role!.id!,
                                //           );
                                //         },
                                //       );
                                //     },
                                //     icon: const Icon(Icons.delete)),