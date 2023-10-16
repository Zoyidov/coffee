import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee/utils/colors/app_colors.dart';
import 'package:coffee/utils/images/app_images.dart';
import 'package:coffee/widgets/global_button.dart';
import 'package:coffee/widgets/global_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../widgets/dialog.dart';
import '../../../widgets/open_camera_gallery_dialog.dart';
import '../../../widgets/snackbar.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  String? selectedImagePath;

  @override
  void initState() {
    super.initState();
    selectedImagePath != null;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addCoffeeToFirestore(String name, String type,
      String description, double price, String imageUrl) async {
    try {
      await firestore.collection('coffees').add({
        'name': name,
        'type': type,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
      });
    // ignore: empty_catches
    } catch (e) {
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.c_201,
        title: const Text("Add coffe"),
      ),
      backgroundColor: AppColors.c_201,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 270,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white),
                  borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: selectedImagePath == null
                    ? Center(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.c_EFE3),
                          child: ZoomTapAnimation(
                            onTap: () {
                              showCameraAndGalleryDialog(context, (imagePath) {
                                if (imagePath != null) {
                                  setState(() {
                                    selectedImagePath = imagePath;
                                  });
                                }
                              });
                            },
                            child: SvgPicture.asset(AppImages.camera),
                          ),
                        ),
                      )
                    : Image.file(
                        File(selectedImagePath!),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  GlobalTextField(
                    hintText: 'Name',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    caption: '',
                    controller: nameController,
                  ),
                  GlobalTextField(
                    hintText: 'Type',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    caption: '',
                    controller: typeController,
                  ),
                  GlobalTextField(
                    hintText: 'Description',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    caption: '',
                    controller: descriptionController,
                  ),
                  GlobalTextField(
                      controller: priceController,
                      hintText: "Price",
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      caption: ""),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ZoomTapAnimation(
                child: GlobalButton(
                  buttonText: 'Add',
                  iconData: Icons.coffee_rounded,
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        typeController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        double.tryParse(priceController.text) != null) {
                      double price = double.parse(priceController.text);
                      addCoffeeToFirestore(
                        nameController.text,
                        typeController.text,
                        descriptionController.text,
                        price,
                        selectedImagePath!,
                      );
                      nameController.clear();
                      typeController.clear();
                      descriptionController.clear();
                      priceController.clear();

                      GlobalAwesomeDialog.showCustomDialog(
                        context,
                        'Success',
                        'This is a success message.',
                        // ignore: deprecated_member_use
                        DialogType.SUCCES,
                      );
                    } else {
                      GlobalSnackbar.showSnackbar(
                        context,
                        'Please fill in all fields and provide a valid price.',
                      );
                    }
                  },
                  buttonColor: AppColors.c_EFE3,
                  iconColor: AppColors.black,
                  textColor: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
