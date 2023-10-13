// ignore_for_file: prefer_const_constructors

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hrcosmoemployee/Navigation/locator.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/dashboard.dart';
import 'package:hrcosmoemployee/Screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // await Upgrader.clearSavedSettings();
  setupLocator();
  runApp(RootRestorationScope(
      restorationId: 'root',
      child: MyApp(
        isLoggedIn: isLoggedIn,
      )));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HR COSMO EMPLOYEE',
            theme: ThemeData(
              fontFamily: 'FontMain',
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            home: isLoggedIn
                ? DashboardScreen()
                : AnimatedSplashScreen(
                    splash: "assets/appLogo.png",
                    splashIconSize: 42,
                    animationDuration: Duration(milliseconds: 2100),
                    splashTransition: SplashTransition.fadeTransition,
                    backgroundColor: Color.fromARGB(255, 234, 240, 255),
                    nextScreen: LoginScreen(),
                  ),
          );
        });
  }
}
