import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:coffee/utils/colors/app_colors.dart';
import 'package:coffee/widgets/global_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../widgets/dialog.dart';

class CoffeeDetailScreen extends StatelessWidget {
  final String name;
  final String type;
  final String description;
  final double price;
  final String imageUrl;

  const CoffeeDetailScreen({super.key,
    required this.name,
    required this.type,
    required this.price,
    required this.imageUrl, required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c_201,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/3,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.file(
                  File(imageUrl),
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        fit: BoxFit.fill,
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3r1s8qt1jMFd_y-bzV8skZdYb6PYQgUKIAq7BXzuv6peeWIHsjPzK7seb7mrXgePv0a4&usqp=CAU'),
                    );
                  },
                ),
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        )),
                    const SizedBox(height: 10),
                    Text(type,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14.000000953674316,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 35.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )),
                    Text("₹249",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                ZoomTapAnimation(
                    child: GlobalButton(
                        buttonText: 'Book now',
                        iconData: Icons.coffee_rounded,
                        onPressed: () {
                          CustomDialog.showCustomDialog(
                              context,
                              name,
                              'Buyutma qabul qilindi',
                          );
                        },
                        buttonColor: AppColors.c_EFE3,
                        textColor: AppColors.black))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
