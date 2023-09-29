import 'package:flutter/material.dart';

// way to call this snackbar:
// ScaffoldMessenger.of(context).showSnackBar(MainSnackBar.show("Message"));

class CustomSnackBar {
  static show(
      {required String message,
      int duration = 3000,
      Color color = Colors.blue}) {
    return SnackBar(
      duration: Duration(milliseconds: duration),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 260.0,
            child: Text(
              message,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
          const Icon(Icons.error),
        ],
      ),
      backgroundColor: color,
    );
  }
  // static void showMySnackBar(var _scaffoldKey, String message) {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(
  //     backgroundColor: Colors.green,
  //     content: Text(message ?? ""),
  //     duration: Duration(seconds: 2),
  //   ));
  // }
}
