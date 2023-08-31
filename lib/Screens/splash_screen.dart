import 'package:final_projectt/Screens/home.dart';
import 'package:final_projectt/Screens/login_screen.dart';
import 'package:final_projectt/Screens/main_screen.dart';
import 'package:final_projectt/core/helpers/shared_prefs.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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

  @override
  void initState() {
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
