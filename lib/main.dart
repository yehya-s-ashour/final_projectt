import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/providers/all_user_provider.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:final_projectt/providers/rtl_provider.dart';
import 'package:final_projectt/providers/status_provider.dart';
import 'package:final_projectt/providers/user_provider.dart';
import 'package:final_projectt/providers/user_role_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/language',
    fallbackLocale: const Locale('en'),
    child: const myapp(),
  ));
}

class myapp extends StatelessWidget {
  const myapp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: backGroundColor),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => UserProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => StatuseProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => NewInboxProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => AllUserProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => UserRoleProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => RTLPro()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          theme: ThemeData(fontFamily: 'Iphone'),
          home: const SplashScreen()),
    );
  }
}
