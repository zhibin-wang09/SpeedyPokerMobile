import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speedy_poker/page/home_page.dart';

// a helper function used whenever an error occurred in the game and we need to disconnect from the game
void showErrorAndBack(
  BuildContext context,
  String errorMessage,
  ToastGravity toastGravity,
  Color backgroundColor,
  Color textColor,
) {
  Fluttertoast.showToast(
    msg: errorMessage,
    toastLength: Toast.LENGTH_SHORT,
    gravity: toastGravity,
    timeInSecForIosWeb: 3,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: 16.0,
  );

  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
    builder: (context) => SpeedyPoker(),
  ),
  (Route<dynamic> route) => false,);
}
