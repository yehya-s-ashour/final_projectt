import 'package:final_projectt/Screens/home.dart';
import 'package:final_projectt/Screens/main_screen.dart';
import 'package:final_projectt/core/helpers/shared_prefs.dart';
import 'package:final_projectt/core/services/auth_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/show_alert.dart';
import 'package:final_projectt/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isToggled = false;
  int initialLabelIndex = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailOrUserNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  void submitRegister() {
    if (_formKey.currentState!.validate()) {
      AuthController.register(context,
              name: nameController.text,
              email: emailOrUserNameController.text,
              password: passController.text,
              passwordConfirmation: confirmPassController.text)
          .then((response) async {
        // if (response[0] == 200) {
        SharedPrefsController _prefs = SharedPrefsController();
        await _prefs.setData('user', userToJson(User.fromJson(response[1])));
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ));
        // }
        // else if (response[0] == 400) {
        //   showAlert(context,
        //       message: 'This email is used before');
        // }
      }).catchError((err) {
        showAlert(context, message: "Email is already register");
      });
    }
  }

  void submitLogin() {
    if (_formKey.currentState!.validate()) {
      AuthController.login(
        context,
        email: emailOrUserNameController.text,
        password: passController.text,
      ).then((response) async {
        SharedPrefsController _prefs = SharedPrefsController();
        await _prefs.setData('user', userToJson(User.fromJson(response[1])));
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return MainPage();
          },
        ));
      }).catchError((err) {
        showAlert(context, message: "there some thing error: $err");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 234, 229, 229),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(110),
                      bottomRight: Radius.circular(200)),
                ),
                child: Image.asset(
                  'images/splash.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 220),
                width: 350,
                height: 570,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(80)),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: 60.0,
                    end: 60.0,
                    start: 60.0,
                  ),
                  child: Column(
                    children: [
                      ToggleSwitch(
                        fontSize: 16,
                        minWidth: 100.0,
                        cornerRadius: 20.0,
                        activeBgColors: [
                          [Colors.blue[800]!],
                          [Colors.blue[800]!]
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor:
                            const Color.fromARGB(255, 234, 232, 232),
                        inactiveFgColor: Colors.blue[800]!,
                        initialLabelIndex: initialLabelIndex,
                        totalSwitches: 2,
                        labels: const ['Log In', 'Sign Up'],
                        radiusStyle: true,
                        onToggle: (index) {
                          setState(() {
                            isToggled = !isToggled;
                            print(isToggled);
                            initialLabelIndex = index!;
                          });
                        },
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Enter your name',
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Iphone',
                                      fontSize: 14),
                                  fillColor: Colors.grey,
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey))),
                            ),
                            TextFormField(
                              controller: emailOrUserNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email or username';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Enter email or username',
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Iphone',
                                      fontSize: 14),
                                  fillColor: Colors.grey,
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey))),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: passController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ' Please enter a password  ';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Iphone',
                                      fontSize: 14),
                                  fillColor: Colors.grey,
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey))),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            if (isToggled)
                              Column(
                                children: [
                                  TextFormField(
                                    controller: confirmPassController,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      } else if (value != passController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Confirm Password',
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Iphone',
                                            fontSize: 14),
                                        fillColor: Colors.grey,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
                            TextButton(
                              onPressed: () {
                                if (isToggled) {
                                  if (_formKey.currentState!.validate()) {
                                    submitRegister();
                                  }
                                } else {
                                  if (_formKey.currentState!.validate()) {
                                    submitLogin();
                                  }

                                  // if (Form.of(context).validate()) {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const HomeScreen()),
                                  //   );
                                  // }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 32.0),
                                child: Text(
                                  isToggled ? 'Sign Up' : 'Log In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Text(
                              'OR',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 210, 208, 208)),
                                    ),
                                    child: Logo(
                                      Logos.facebook_f,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 210, 208, 208)),
                                    ),
                                    child: Logo(
                                      Logos.twitter,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 210, 208, 208)),
                                    ),
                                    child: Logo(
                                      Logos.google,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
