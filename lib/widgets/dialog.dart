import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class GlobalAwesomeDialog {
  static void showCustomDialog(
      BuildContext context,
      String title,
      String desc,
      DialogType dialogType,
      ) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.SCALE,
      title: title,
      desc: desc,
      btnCancelOnPress: () {
        Navigator.of(context).pop();
      },
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
    ).show();
  }
}
