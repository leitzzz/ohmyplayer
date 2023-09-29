import 'package:flutter/material.dart';

class VideoErrorAlert extends StatelessWidget {
  final Color color;
  final String message;
  final Color textColor;

  const VideoErrorAlert(
      {super.key,
      this.textColor = Colors.white,
      required this.message,
      this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20,
        right: 20,
        child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(5)),
            child: Text(
              message,
              style: TextStyle(color: textColor),
            )));
  }
}
