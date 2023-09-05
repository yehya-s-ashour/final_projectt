import 'dart:convert';

import 'package:final_projectt/Screens/main_screen.dart';
import 'package:final_projectt/core/helpers/shared_prefs.dart';
import 'package:final_projectt/core/services/auth_controller.dart';
import 'package:final_projectt/core/services/logout_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/show_alert.dart';
import 'package:final_projectt/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        showAlert(context,
            message: "Account Created Successfully,\n Please Log In",
            color: Colors.grey,
            width: 300);
        _formKey.currentState!.reset();
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        ));
      }).catchError((err) async {
        final errorMessagae =
            json.decode(err.message)['errors']['email'][0].toString();
        showAlert(context,
            message: errorMessagae, color: Colors.redAccent, width: 300);
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
        SharedPrefsController prefs = SharedPrefsController();
        await prefs.setData('user', userToJson(User.fromJson(response[1])));
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const MainPage();
          },
        ));
      }).catchError((err) async {
        final errorMessagae = json.decode(err.message)['message'].toString();
        showAlert(context,
            message: errorMessagae, color: Colors.redAccent, width: 300);
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: 400,
                  height: 400,
                  decoration: const BoxDecoration(
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
                  margin: const EdgeInsets.only(top: 220),
                  width: 350,
                  height: initialLabelIndex == 1 ? 570 : 470,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(80)),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 60.0,
                      end: 60.0,
                      start: 60.0,
                    ),
                    child: Column(
                      children: [
                        // ToggleSwitch(
                        //   fontSize: 16,
                        //   minWidth: 100.0,
                        //   cornerRadius: 20.0,
                        //   activeBgColors: [
                        //     [Colors.blue[800]!],
                        //     [Colors.blue[800]!]
                        //   ],
                        //   activeFgColor: Colors.white,
                        //   inactiveBgColor:
                        //       const Color.fromARGB(255, 234, 232, 232),
                        //   inactiveFgColor: Colors.blue[800]!,
                        //   initialLabelIndex: initialLabelIndex,
                        //   totalSwitches: 2,
                        //   labels: const ['Log In', 'Sign Up'],
                        //   radiusStyle: true,
                        //   onToggle: (index) {
                        //     setState(() {
                        //       // isToggled = !isToggled;
                        //       initialLabelIndex = index!;
                        //     });
                        //   },
                        // ),
                        Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    initialLabelIndex = 0;
                                  });
                                },
                                child: Container(
                                  height: 45,
                                  width: 99,
                                  decoration: BoxDecoration(
                                    color: initialLabelIndex == 0
                                        ? primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Log In',
                                      style: TextStyle(
                                          color: initialLabelIndex == 0
                                              ? Colors.white
                                              : primaryColor,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    initialLabelIndex = 1;
                                  });
                                },
                                child: Container(
                                  height: 45,
                                  width: 99,
                                  decoration: BoxDecoration(
                                    color: initialLabelIndex == 1
                                        ? primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          color: initialLabelIndex == 1
                                              ? Colors.white
                                              : primaryColor,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (initialLabelIndex == 1)
                                TextFormField(
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
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
                                decoration: const InputDecoration(
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
                              const SizedBox(
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
                                decoration: const InputDecoration(
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
                              const SizedBox(
                                height: 15,
                              ),
                              if (initialLabelIndex == 1)
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: confirmPassController,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please confirm your password';
                                        } else if (value !=
                                            passController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: 'Confirm Password',
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Iphone',
                                              fontSize: 14),
                                          fillColor: Colors.grey,
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey))),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                  ],
                                ),
                              TextButton(
                                onPressed: () {
                                  if (initialLabelIndex == 1) {
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 32.0),
                                  child: Text(
                                    initialLabelIndex == 1
                                        ? 'Sign Up'
                                        : 'Log In',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              const Text(
                                'OR',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
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
                                      padding: const EdgeInsets.symmetric(
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
                                      padding: const EdgeInsets.symmetric(
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
          ),
        ));
  }
}
