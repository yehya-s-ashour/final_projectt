import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../core/util/constants/colors.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isToggled = false;
  int initialLabelIndex = 0;
  @override
  Widget build(BuildContext context) {
    TextEditingController emailOrUserNameController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();

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
                height: 550,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(80)),
                child: Padding(
                  padding: const EdgeInsets.all(60.0),
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
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        child: Column(
                          children: [
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
                            if (isToggled)
                              Column(
                                children: [
                                  TextFormField(
                                    controller: confirmPassController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      } else if (value != passController.text) {
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
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
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
                                if (isToggled) {
                                  if (Form.of(context).validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainPage()),
                                    );
                                  }
                                } else {
                                  if (Form.of(context).validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainPage()),
                                    );
                                  }
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
                                  isToggled ? 'Sign Up' : 'Log In',
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
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
                                    padding: const EdgeInsets.all(8),
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
