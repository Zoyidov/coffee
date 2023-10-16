// ignore_for_file: library_private_types_in_public_api

import 'package:coffee/presentation/auth/auth_screen.dart';
import 'package:coffee/presentation/on_boarding/widget/center_dots.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../utils/colors/app_colors.dart';
import '../../utils/images/app_images.dart';
import '../../widgets/global_button.dart';

class LowerShadowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  List<String> imageAssets = [
    AppImages.first,
    AppImages.second,
    AppImages.third,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            allowImplicitScrolling: true,
            controller: _pageController,
            itemCount: imageAssets.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                imageAssets[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          ClipPath(
            clipper: LowerShadowClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.black.withOpacity(0.99),
                    AppColors.black.withOpacity(0.5),
                    AppColors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  imageAssets.indexOf(imageAssets[_currentPageIndex]) == 0
                      ? "Sospeso is a cup of coffee paid for in advance as ananonymous act of charity."
                      : imageAssets.indexOf(imageAssets[_currentPageIndex]) == 1
                          ? "If you experienced good luck order a sospeso, paying the price of two coffees but receiving and consumingonly one."
                          : "Get a free coffee if you don't have money but need it tostart your lucky day.",
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                height: 115,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.c_201.withOpacity(0.3),
                      AppColors.white.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CenterDots(activeDotIndex: _currentPageIndex),
                      ZoomTapAnimation(
                        child: GlobalButton(
                          buttonText: _currentPageIndex == 0
                              ? '    Next'
                              : _currentPageIndex == 1
                                  ? '    Next'
                                  : '      Continue',
                          iconData: Icons.arrow_forward_ios,
                          onPressed: () {
                            if (_currentPageIndex < imageAssets.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.ease,
                              );
                            }
                            if (_currentPageIndex == 2) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const AuthScreen()));
                            }
                          }, buttonColor: AppColors.white, textColor: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
