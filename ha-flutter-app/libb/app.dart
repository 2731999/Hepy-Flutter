import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hepy/app/Utils/app_them.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/modules/welcome/binding/welcome_binding.dart';
import 'package:hepy/app/routes/app_pages.dart';
import 'package:hepy/app/widgets/swipecards/card_provider.dart';
import 'package:hepy/app_config.dart';
import 'package:provider/provider.dart';

Future<Widget> initializeApp(AppConfig appConfig) async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();

  try {
    PreferenceUtils.setAppConfig = appConfig;
  } on Exception catch (_) {}

  return Hepy();
}

class Hepy extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => CardProvider(),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Application',
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: AppThem.of.themeData(),
          initialBinding: WelcomeBinding(),
        ),
      );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
