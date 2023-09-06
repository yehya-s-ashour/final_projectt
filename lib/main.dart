import 'package:final_projectt/providers/status_provider.dart';
import 'package:final_projectt/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(fontFamily: 'Iphone'),
//     home: SplashScreen(),
//   ));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    child: const myapp(),
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/language',
    fallbackLocale: const Locale('en'),
  ));
}

class myapp extends StatelessWidget {
  const myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => UserProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => StatuseProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          theme: ThemeData(fontFamily: 'Iphone'),
          home: SplashScreen()),
    );
  }
}