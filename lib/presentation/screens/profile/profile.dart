import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../utils/images/app_images.dart';
import '../../../widgets/global_button.dart';
import '../../../widgets/log_out_dialog.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? userName;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserName = prefs.getString('userName');
    final savedPhoneNumber = prefs.getString('phoneNumber');

    setState(() {
      userName = savedUserName;
      phoneNumber = savedPhoneNumber;
    });
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final bool? confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LogoutDialog();
      },
    );

    if (confirmLogout != null && confirmLogout) {
      // Handle the logout action if needed.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.c_201,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(AppImages.second),
          ),
          const SizedBox(height: 20),
          Text(
            userName ?? 'John Doe',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            phoneNumber ?? '+1 (123) 456-7890',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GlobalButton(
              buttonText: 'Log Out',
              iconData: Icons.logout,
              onPressed: () {
                _showLogoutDialog(context);
              },
              buttonColor: AppColors.c_201,
              textColor: AppColors.white,
              iconColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
