// import 'package:final_projectt/core/services/profile_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:final_projectt/core/util/constants/colors.dart';
// import 'package:final_projectt/core/util/constants/styles.dart';
// import 'package:final_projectt/core/widgets/button_widget.dart';
// import 'dart:io';

// @immutable
// class EditProfile extends StatefulWidget {
//   late String defaultName;
//   late String? defaultImagePath;

//   EditProfile(
//       {Key? key, required this.defaultName, required this.defaultImagePath})
//       : super(key: key);

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   String get defaultName => widget.defaultName;
//   String get defaultImagePath => widget.defaultImagePath!;
//   late TextEditingController nameController;
//   File? pickedFile;
//   String? filePath;
//   String? currentImagePath;

//   resetDeafultPath() async {
//     widget.defaultImagePath = await getNewProfilePic();
//   }

//   @override
//   void initState() {
//     nameController = TextEditingController(text: defaultName);
//     pickedFile == null;
//     resetDeafultPath();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // resetDeafultPath();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Edit Profile",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: backGroundColor,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(
//               height: 50,
//             ),
//             Center(
//               child: Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   Container(
//                     height: 200,
//                     width: 200,
//                     clipBehavior: Clip.antiAliasWithSaveLayer,
//                     decoration:
//                         BoxDecoration(borderRadius: BorderRadius.circular(100)),
//                     child: pickedFile == null
//                         ? Image.network(
//                             'https://palmail.gsgtt.tech/storage/${widget.defaultImagePath}',
//                             fit: BoxFit.cover,
//                           )
//                         : Image.file(File(pickedFile!.path)),
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       pickedFile = await pickImageFile();

//                       if (pickedFile != null) {
//                         filePath = pickedFile!.path;
//                       }
//                       setState(() {});
//                     },
//                     child: Container(
//                       width: 50,
//                       height: 50,
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       decoration: BoxDecoration(
//                           color: primaryColor,
//                           borderRadius: BorderRadius.circular(25)),
//                       child: const Icon(
//                         Icons.camera_alt,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 50,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(32.0),
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: nameController,
//                     decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 12),
//                       labelText: 'Name:',
//                       labelStyle: TextStyle(color: primaryColor),
//                       border: Styles.primaryUnderlineInputBorder,
//                       focusedBorder: Styles.primaryUnderlineInputBorder,
//                       errorBorder: Styles.primaryUnderlineInputBorder,
//                       enabledBorder: Styles.primaryUnderlineInputBorder,
//                       disabledBorder: Styles.primaryUnderlineInputBorder,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   ButtonWidget(
//                     onTap: () async {
//                       await uploadProfilePicAndName(
//                               pickedFile!, nameController.text)
//                           .then((value) async {
//                         final newImage = await getNewProfilePic();
//                         updateSharedPreferences(nameController.text, newImage!);
//                         if (mounted) {
//                           Navigator.pop(context, pickedFile);
//                         }
//                       }).catchError((err) {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text(err.toString()),
//                           backgroundColor: Colors.red,
//                         ));
//                       });
//                     },
//                     text: 'UPDATE PROFILE',
//                     width: 200,
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
