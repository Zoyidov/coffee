import 'package:coffee/presentation/tab_box/tab_box_user.dart';
import 'package:coffee/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../widgets/global_textfield.dart';
import '../tab_box/tab_box_admin.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c_201,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.c_201,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 20.0),
                child: Text(
                  'Please enter your name and phone number so we can contact you.',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GlobalTextField(
                      controller: userName,
                      hintText: 'Username',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.person,
                      caption: '',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'We need to know who you are!';
                        }
                        return null;
                      },
                    ),
                    GlobalTextField(
                      controller: phoneNumber,
                      hintText: 'Phone number',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.phone,
                      caption: '',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This is very important for us to contact you!';
                        }
                        final phonePattern = RegExp(r'^\+\(\d{3}\) \d{2} \d{3}-\d{2}-\d{2}$');
                        if (!phonePattern.hasMatch(value)) {
                          return 'Please enter a valid phone number in the format +(XXX) XX XXX-XX-XX';
                        }
                        return null;
                      },

                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ZoomTapAnimation(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      final String name = userName.text;
                      final String phone = phoneNumber.text;

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('userName', name);
                      await prefs.setString('phoneNumber', phone);

                      if (name == "admin" && phone == "+(998) 77 777-77-77") {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TabBoxAdmin()));
                      } else {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TabBoxUser()));
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 5),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
