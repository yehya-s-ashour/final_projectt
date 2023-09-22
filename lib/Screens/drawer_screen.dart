// import 'package:easy_localization/easy_localization.dart';
// import 'package:final_projectt/Screens/profile_page.dart';
// import 'package:final_projectt/Screens/sender_screen.dart';
// import 'package:final_projectt/Screens/user_management_screen.dart';
// import 'package:final_projectt/core/util/constants/colors.dart';
// import 'package:final_projectt/providers/all_user_provider.dart';
// import 'package:final_projectt/providers/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:provider/provider.dart';

// Widget drawer(BuildContext context) {
//   List<Map> drawerItem = [
//     {'icon': Icons.home, 'title': 'Home Page'},
//     {'icon': Icons.person, 'title': 'Profile Page'},
//     {'icon': MdiIcons.sendCheck, 'title': 'Senders'},
//     {'icon': Icons.settings, 'title': 'User Management'},
//   ];
//   return SafeArea(
//     child: Container(
//       height: MediaQuery.of(context).size.height,
//       width: double.infinity,
//       padding: context.locale.toString() == 'ar'
//           ? const EdgeInsets.only(top: 80, right: 20, bottom: 20)
//           : const EdgeInsets.only(top: 80, left: 20, bottom: 20),
//       color: primaryColor,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: context.locale.toString() == 'ar'
//                 ? EdgeInsets.only(
//                     right: MediaQuery.of(context).size.width * 0.15)
//                 : EdgeInsets.only(
//                     left: MediaQuery.of(context).size.width * 0.15),
//             height: 100,
//             width: 100,
//             child: Image.asset('images/pal.png'),
//           ),
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.08,
//           ),
//           Column(
//               children: drawerItem
//                   .map((e) => Row(
//                         children: [
//                           Icon(
//                             e['icon'],
//                             color: Colors.white,
//                             size: 25,
//                           ),
//                           const SizedBox(
//                             height: 50,
//                             width: 10,
//                           ),
//                           TextButton(
//                             onPressed: () async {
//                               switch (e["title"]) {
//                                 case "Home Page":
//                                   print('home');
//                                 case "Senders":
//                                   Navigator.push(context, MaterialPageRoute(
//                                     builder: (context) {
//                                       return const SendersScreen();
//                                     },
//                                   ));
//                                 case "Profile Page":
//                                   Navigator.push(context, MaterialPageRoute(
//                                     builder: (context) {
//                                       return const ProfileScreen();
//                                     },
//                                   ));
//                                 case "User Management":
//                                   // ignore: await_only_futures
//                                   int id = await Provider.of<UserProvider>(
//                                           context,
//                                           listen: false)
//                                       .data
//                                       .data!
//                                       .user
//                                       .role!
//                                       .id!;

//                                   if (id == 4) {
//                                     // ignore: use_build_context_synchronously
//                                     Provider.of<AllUserProvider>(context,
//                                             listen: false)
//                                         .UpdateAllUserProvider();
//                                     // ignore: use_build_context_synchronously
//                                     Navigator.push(context, MaterialPageRoute(
//                                       builder: (context) {
//                                         return const UserManagementScreen();
//                                       },
//                                     ));
//                                   } else {
//                                     // ignore: use_build_context_synchronously
//                                     showDialog(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return AlertDialog(
//                                             shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         32.0)),
//                                             titlePadding:
//                                                 const EdgeInsets.all(0),
//                                             contentPadding:
//                                                 const EdgeInsets.all(16),
//                                             title: Container(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 24),
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       const BorderRadius.only(
//                                                           topLeft:
//                                                               Radius.circular(
//                                                                   32),
//                                                           topRight:
//                                                               Radius.circular(
//                                                                   32)),
//                                                   color: primaryColor),
//                                               child: Column(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Text(
//                                                     "Entry is restricted".tr(),
//                                                     style: const TextStyle(
//                                                         fontSize: 24,
//                                                         color: Colors.white),
//                                                   ),
//                                                   const Padding(
//                                                     padding: EdgeInsets.only(
//                                                         top: 16.0),
//                                                     child: CircleAvatar(
//                                                       backgroundImage: AssetImage(
//                                                           "images/images.png"),
//                                                       radius: 50,
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                             content: Text(
//                                               "Please check with the admin to obtain access permission"
//                                                   .tr(),
//                                               style:
//                                                   const TextStyle(fontSize: 20),
//                                             ),
//                                             actions: [
//                                               TextButton(
//                                                   onPressed: () {
//                                                     Navigator.pop(context);
//                                                   },
//                                                   child: Text("OK".tr()))
//                                             ],
//                                           );
//                                         });
//                                   }

//                                   break;
//                               }
//                             },
//                             child: Text(
//                               "${e['title']}".tr(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 17,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ))
//                   .toList()),
//           const Spacer(),
//           Container(
//             margin:
//                 EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
//             child: Row(
//               children: [
//                 TextButton(
//                   onPressed: () {},
//                   child: Text(
//                     'Terms Of Service'.tr(),
//                     style: const TextStyle(
//                         color: Color.fromARGB(255, 179, 178, 178),
//                         fontSize: 12),
//                   ).tr(),
//                 ),
//                 Container(
//                   width: 1.2,
//                   height: 15,
//                   color: const Color.fromARGB(255, 179, 178, 178),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: Text(
//                     'Usage Policy'.tr(),
//                     style: const TextStyle(
//                         color: Color.fromARGB(255, 179, 178, 178),
//                         fontSize: 12),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
