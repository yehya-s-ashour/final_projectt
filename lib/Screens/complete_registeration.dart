import 'dart:io';
import 'dart:ui';

import 'package:final_projectt/Screens/main_screen.dart';
import 'package:final_projectt/core/services/profile_controller.dart';
import 'package:final_projectt/core/services/user_controller.dart';
import 'package:final_projectt/models/user_model.dart';
import 'package:final_projectt/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CompleteRegisteration extends StatefulWidget {
  const CompleteRegisteration({super.key});

  @override
  State<CompleteRegisteration> createState() => _CompleteRegisterationState();
}

class _CompleteRegisterationState extends State<CompleteRegisteration> {
  File? pickedFile;
  bool isUploading = false;
  String? filePath;
  late String name;
  late Future<UserModel> user;

  @override
  void initState() {
    user = UserController().getLocalUser();

    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            CustomPaint(
              size: Size(double.infinity, MediaQuery.of(context).size.height),
              painter: MyPainter(),
            ),
            Positioned(
              left: 20,
              top: 40,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const MainPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        var end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 20),
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 140,
              top: MediaQuery.of(context).size.height / 2 - 270,
              child: Text(
                'Upload Your\n Profile Image',
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 1.3,
                    height: 1.5,
                    color: Colors.white,
                    fontSize: 35,
                    fontFamily: 'Arvo',
                    fontWeight: FontWeight.w800),
              ),
            ),
            GestureDetector(
              onTap: () async {
                pickedFile = await pickImageFile();

                if (pickedFile != null) {
                  filePath = pickedFile!.path;
                }
                setState(() {});
              },
              child: Stack(
                children: [
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 150,
                    top: MediaQuery.of(context).size.height / 2 - 140,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 150,
                      backgroundImage: pickedFile == null
                          ? AssetImage('images/profile.png')
                          : FileImage(
                              File(pickedFile!.path),
                            ) as ImageProvider<Object>,
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 + 80,
                    top: MediaQuery.of(context).size.height / 2 + 100,
                    child: Container(
                      width: 45,
                      height: 45,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 115,
              top: MediaQuery.of(context).size.height / 2 + 210,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade400,
                    padding: EdgeInsets.only(
                        left: 70, right: 70, top: 12, bottom: 12)),
                onPressed: () async {
                  await user.then((userData) => {
                        name = userData.user.name!,
                      });
                  setState(() {
                    isUploading = true;
                  });
                  isUploading
                      ? showCupertinoDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return Center(
                                child: SpinKitPulse(
                              duration: Duration(milliseconds: 1000),
                              color: Colors.white,
                              size: 40,
                            ));
                          },
                        )
                      : null;
                  await uploadProfilePic(pickedFile!, name).then((value) async {
                    final newImage = await getNewProfilePic();
                    updateSharedPreferences(name, newImage!).then((value) {
                      setState(() {
                        isUploading = false;
                      });
                    });

                    Provider.of<UserProvider>(context, listen: false)
                        .getUserData();
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const MainPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          var end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  }).catchError((err) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(err.toString()),
                      backgroundColor: Colors.red,
                    ));
                  });
                },
                child: Text(
                  'Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 23),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue, Colors.green], // Specify your gradient colors
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
          Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)))
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.35);
    path.lineTo(0, size.height / 1.4);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
