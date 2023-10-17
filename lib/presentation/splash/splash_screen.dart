// ignore_for_file: library_private_types_in_public_api

import 'package:coffee/presentation/tab_box/tab_box_user.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/images/app_images.dart';
import '../on_boarding/onboarding_screen.dart';
import '../auth/auth_screen.dart';
import '../tab_box/tab_box_admin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthenticationAndFirstLaunch();
  }

  void _checkAuthenticationAndFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('firstLaunch') ?? true;

    await Future.delayed(const Duration(seconds: 3));

    if (isFirstLaunch) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OnBoardingScreen(),
        ),
      );
      prefs.setBool('firstLaunch', false);
    } else {
      final userName = prefs.getString('userName');
      final userPhone = prefs.getString('userPhone');

      if (userName == "admin" && userPhone == "+(998) 77 777-77-77") {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TabBoxAdmin(),
          ),
        );
      } else if (userName != null && userPhone != null) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TabBoxUser(),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
        );
      }
    }
  }

  Future<String?> checkUserAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName');
    final userPhone = prefs.getString('userPhone');

    if ((userName == "admin" && userPhone == "+(998) 77 777-77-77") ||
        (userName != null && userPhone != null)) {
      // User or admin is already registered
      return "registered";
    } else {
      // User is not registered
      return "unregistered";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Lottie.asset(AppImages.splash),
      ),
    );
  }
}
