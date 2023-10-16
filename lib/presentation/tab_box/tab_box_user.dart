import 'package:coffee/presentation/screens/cart/cart.dart';
import 'package:coffee/presentation/screens/home/home_user.dart';
import 'package:coffee/presentation/screens/profile/profile.dart';
import 'package:coffee/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/cubit/tab_cubit.dart';
import '../../utils/images/app_images.dart';

// ignore: must_be_immutable
class TabBoxUser extends StatelessWidget {
  TabBoxUser({super.key});

  List<Widget> pages = [
    const HomeUser(),
     Cart(),
     Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: context.watch<TabCubit>().state,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.c_201.withOpacity(0.93),
        elevation: 0,
        currentIndex: context.watch<TabCubit>().state,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: context.read<TabCubit>().changeTab,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppImages.home,
            ),
            activeIcon: SvgPicture.asset(
              AppImages.home,
              color: AppColors.c_FDA429,
            ),
            label: '•',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.cart),
            activeIcon: SvgPicture.asset(
              AppImages.cart,
              color: AppColors.c_FDA429,
            ),
            label: '•',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.profile),
            activeIcon: SvgPicture.asset(
              AppImages.profile,
              // ignore: deprecated_member_use
              color: AppColors.c_FDA429,
            ),
            label: '•',
          ),
        ],
      ),
    );
  }


}
