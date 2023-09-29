import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';

class MarqueeText extends StatelessWidget {
  final String text;

  const MarqueeText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Marquee(
      textDirection: TextDirection.ltr,
      directionMarguee: DirectionMarguee.oneDirection,
      child: Text(
        text,
        softWrap: true,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 11.0,
            overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
