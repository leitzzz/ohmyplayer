import 'package:flutter/material.dart';

class ChannelLogo extends StatelessWidget {
  final String channelLogo;

  const ChannelLogo({super.key, required this.channelLogo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      // child: Image.network(channel.logo),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: FadeInImage(
          image: NetworkImage(channelLogo),
          placeholder: const AssetImage("assets/images/loading.gif"),
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/noimage.png',
                fit: BoxFit.fitWidth);
          },
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
