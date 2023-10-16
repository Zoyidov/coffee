import 'package:coffee/presentation/tab_box/tab_box_user.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/images/app_images.dart';
import '../on_boarding/onboarding_screen.dart';
import '../auth/auth_screen.dart';

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

    await Future.delayed(Duration(seconds: 3));

    if (isFirstLaunch) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OnBoardingScreen(),
        ),
      );
      prefs.setBool('firstLaunch', false);
    } else {
      bool isUserAuthenticated = await checkUserAuthentication();

      if (isUserAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TabBoxUser(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AuthScreen(),
          ),
        );
      }
    }
  }

  Future<bool> checkUserAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('userToken');

    return userToken != null;
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
