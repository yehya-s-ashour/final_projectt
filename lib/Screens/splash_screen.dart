import 'package:final_projectt/Screens/login_screen.dart';
import 'package:final_projectt/Screens/main_screen.dart';
import 'package:final_projectt/core/helpers/shared_prefs.dart';
import 'package:final_projectt/core/services/user_controller.dart';
import 'package:final_projectt/models/user_model.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<UserModel> user;
  late bool isImageNull;
  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    SharedPrefsController _prefs = SharedPrefsController();
    bool containsKey = await _prefs.containsKey('user');

    if (mounted) {
      if (containsKey) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  isFirstLogin() async {
    user = UserController().getLocalUser();
    user.then((userData) {
      isImageNull = userData.user.image == null;
    });
  }

  @override
  void initState() {
    isFirstLogin();
    navigateToHome();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Image.asset(
              'images/splash.jpg',
              fit: BoxFit.fill,
            )));
  }
}
