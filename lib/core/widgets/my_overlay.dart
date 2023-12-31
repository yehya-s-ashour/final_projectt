import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/Screens/login_screen.dart';
import 'package:final_projectt/core/helpers/shared_prefs.dart';
import 'package:final_projectt/providers/rtl_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

OverlayEntry? overlayEntry;
AnimationController? animationController;

void hideOverlay() {
  if (overlayEntry != null) {
    overlayEntry!.remove();
    overlayEntry = null;
  }
}

void deletShar() async {
  SharedPrefsController prefs = SharedPrefsController();
  await prefs.deleteData('user');
}

void showOverlay(
  BuildContext context,
  String name,
  String role,
  String? image,
) {
  final overlayState = Overlay.of(context);
  final animationController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: overlayState,
  );

  final animation = Tween<double>(
    begin: 0, // Start off-screen
    end: 1, // End at the desired position
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    ),
  );

  animationController.forward(); // Start the animation

  final overlay = AnimatedBuilder(
    animation: animationController,
    builder: (context, child) {
      return Positioned(
        left: context.locale.toString() == 'ar' ? 16 : 148,
        top: 40,
        child: GestureDetector(
          onTap: () => hideOverlay(),
          behavior: HitTestBehavior.opaque,
          child: Opacity(
            opacity: animation.value,
            child: Transform.scale(
              alignment: Alignment.topCenter,
              scaleY: animation.value,
              child: Container(
                //  curve: Curves.fastOutSlowIn,
                width: 230,
                height: 330,
                // duration: const Duration(seconds: 1),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black,
                      spreadRadius: -2,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(bottom: 8, top: 24),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 223, 130, 123),
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Container(
                        height: 120,
                        width: 120,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100)),
                        child: image != null
                            ? Image.network(
                                "https://palmail.gsgtt.tech/storage/$image",
                                fit: BoxFit.cover,
                              )
                            : Image.asset('images/profile.png',
                                fit: BoxFit.cover),
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
                          context.locale.toString() == "en"
                              ? context.setLocale(const Locale('ar'))
                              : context.setLocale(const Locale('en'));
                          Provider.of<RTLPro>(context, listen: false)
                              .changeOpening();
                          hideOverlay();
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.language,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Language'.tr(),
                              style: const TextStyle(
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
                          deletShar();
                          hideOverlay();
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return const LoginScreen();
                            },
                          ));
                          //  }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.login_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Logout'.tr(),
                              style: const TextStyle(
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
            ),
          ),
        ),
      );
    },
  );

  final background = GestureDetector(
    onTap: () {
      hideOverlay();
    },
    child: Container(
      color: Colors.transparent,
    ),
  );

  overlayEntry = OverlayEntry(builder: (context) {
    return Stack(
      children: [
        background,
        overlay,
      ],
    );
  });

  overlayState.insert(overlayEntry!);
}
