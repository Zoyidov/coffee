import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/cubit/tab_cubit.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/images/app_images.dart';
import '../screens/add/add.dart';
import '../screens/home/home_admin.dart';
import '../screens/profile/profile.dart';

// ignore: must_be_immutable
class TabBoxAdmin extends StatelessWidget {
  TabBoxAdmin({super.key});

  List<Widget> pages = [
    const HomeAdmin(),
    const Add(),
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
        elevation: 5,
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
              // ignore: deprecated_member_use
              color: AppColors.c_FDA429,
            ),
            label: '•',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_circle,size: 30,),
            activeIcon: Icon(Icons.add_circle,color: AppColors.c_FDA429,size: 30,),
            label: '•',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.profile,),
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