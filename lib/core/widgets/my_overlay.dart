import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/Screens/login_screen.dart';
import 'package:final_projectt/core/helpers/shared_prefs.dart';
import 'package:final_projectt/core/services/logout_controller.dart';
import 'package:final_projectt/core/widgets/show_alert.dart';
import 'package:flutter/material.dart';

late OverlayEntry overlayEntry;
bool isen = true;

void hideOverlay() {
  overlayEntry.remove();
}

void showOverlay(BuildContext context, String name, String role) {
  OverlayState overlayState = Overlay.of(context);
  overlayEntry = OverlayEntry(builder: (context) {
    return Positioned(
      left: context.locale.toString() == 'ar' ? 24 : 80,
      top: 50,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(16),
        ),
        width: 250,
        height: 350,
        duration: const Duration(milliseconds: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    hideOverlay();
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              // margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage("images/person.jpg"),
                radius: 60,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(role,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    decoration: TextDecoration.none)),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () {
                  isen
                      ? context.setLocale(const Locale('ar'))
                      : context.setLocale(const Locale('en'));
                  isen = !isen;
                  hideOverlay();
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Language',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () {
                  logout(
                    context,
                  ).then((response) async {
                    SharedPrefsController prefs = SharedPrefsController();
                    await prefs.deleteData('user');
                    hideOverlay();
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    ));
                  }).catchError((err) async {
                    final errorMessagae =
                        json.decode(err.message)['message'].toString();
                    showAlert(context,
                        message: errorMessagae,
                        color: Colors.redAccent,
                        width: 300);
                  });
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.login_outlined,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });

  // Inserting the OverlayEntry into the Overlay
  overlayState.insert(overlayEntry);
}
