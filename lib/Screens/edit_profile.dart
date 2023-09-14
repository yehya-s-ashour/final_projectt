// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:final_projectt/core/helpers/token_helper.dart';
import 'package:final_projectt/core/util/constants/end_points.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/util/constants/styles.dart';
import 'package:final_projectt/core/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  late String defaultName;
  late String defaultImagePath;

  EditProfile(
      {Key? key, required this.defaultName, required this.defaultImagePath})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String get defaultName => widget.defaultName;
  String get defaultImagePath => widget.defaultImagePath;
  late TextEditingController nameController;
  late Future<String>? newImagePath;

  // Future<String?> pickImagePath() async {
  //   final ImagePicker picker = ImagePicker();
  //   XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
  //   print(pickedImage?.path);
  //   return pickedImage?.path;
  // }
  Future<File?> pickImageFile() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return null; // Return null if no image was picked
    }
    File imageFile = File(pickedImage.path);
    return imageFile;
  }

  Future<void> updateImageAndNameProfile(
      File imageFail, String givenName) async {
    String token = await getToken();
    var request =
        http.MultipartRequest("POST", Uri.parse('$baseUrl/user/update'));
    var pic = await http.MultipartFile.fromPath('image', imageFail.path);
    print('the pic path is :$pic');
    request.fields["name"] = givenName; // Use the provided name
    request.fields['title'] = 'image_${DateTime.now()}';
    request.files.add(pic);
    request.headers.addAll(
        {'Accept': 'application/json', 'Authorization': 'Bearer $token'});
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    debugPrint(responseString);
  }

  Future<void> updateNameAndImagePathInSharedPreferences(
      String newName, String newImagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Step 1: Retrieve current user data
    String? userDataString = prefs.getString('user');

    if (userDataString != null) {
      // Step 2: Convert the stored data back to a User object
      User storedUser = userFromJson(userDataString);
      // Step 3 : Filtring the path as required in the image path
      String imagePath = newImagePath;
      List<String> parts = imagePath.split('/cache/');
      String desiredText = parts.length > 1 ? parts[1] : '';
      String filterdPath = 'profiles/$desiredText';

      // Step 4: Update the necessary fields
      storedUser = storedUser.copyWith(
        user: storedUser.user.copyWith(
          // Update the fields you want to change
          name: newName,
          image: filterdPath,
        ),
      );

      // Save the updated user data back to SharedPreferences
      prefs.setString('user', userToJson(storedUser));
    }
  }

  @override
  void initState() {
    nameController = TextEditingController(text: defaultName);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    File? pickedFile;
    String? filePath;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: backGroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)),
                    child: Image.network(
                      'https://palmail.gsgtt.tech/storage/$defaultImagePath',
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      pickedFile = await pickImageFile();
                      if (pickedFile != null) {
                        filePath = pickedFile!.path;
                      }
                      print(filePath);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
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
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      labelText: 'Name:',
                      labelStyle: TextStyle(color: primaryColor),
                      border: Styles.primaryUnderlineInputBorder,
                      focusedBorder: Styles.primaryUnderlineInputBorder,
                      errorBorder: Styles.primaryUnderlineInputBorder,
                      enabledBorder: Styles.primaryUnderlineInputBorder,
                      disabledBorder: Styles.primaryUnderlineInputBorder,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    onTap: () async {
                      await updateImageAndNameProfile(
                              pickedFile!, nameController.text)
                          .then((value) async {
                        await updateNameAndImagePathInSharedPreferences(
                            nameController.text, pickedFile!.path);
                        if (mounted) {
                          Navigator.pop(context, true);
                        }
                      }).catchError((err) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err.toString()),
                          backgroundColor: Colors.red,
                        ));
                      });
                    },
                    text: 'UPDATE PROFILE',
                    width: 200,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
