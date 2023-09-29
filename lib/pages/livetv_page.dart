import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:ohmyplayer/providers/livetv_player_provider.dart';
import 'package:ohmyplayer/providers/livetv_channels_provider.dart';
import 'package:ohmyplayer/config/constants.dart';
import 'package:ohmyplayer/widgets/channel_logo.dart';
import 'package:ohmyplayer/widgets/marquee_text.dart';
import 'package:ohmyplayer/widgets/custom_snackbar.dart';
import 'package:ohmyplayer/widgets/video_error_alert.dart';

// this page template is useful too for Android tv that doesnt supports the Stack widget design.
class LiveTvPage extends StatefulWidget {
  const LiveTvPage({super.key});

  @override
  State<LiveTvPage> createState() => _LiveTvPageState();
}

class _LiveTvPageState extends State<LiveTvPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final liveTvProvider = context.watch<LiveTvChannelsProvider>()
      ..getLiveChannels();
    final livePlayerProvider = context.watch<LivePlayerProvider>()
      ..checkPeriodicStreamState(
          Constants.qtyOfSecondsForStreamValidationStatus);

    // to play the first channel when the app is opened
    if (liveTvProvider.firstChannelUrl.isNotEmpty &&
        !livePlayerProvider.isPlaying) {
      livePlayerProvider.playVideo(liveTvProvider.firstChannelUrl);
    }

    return Scaffold(
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (keyEvent) {
          return _onDKeyPressed(keyEvent, context);
        },
        child: WillPopScope(
          onWillPop: () async {
            liveTvProvider.incrementGoBackCounter();

            if (liveTvProvider.goBackCounter == 3) {
              liveTvProvider.goBackCounter = 0;
              return true;
            }
            return false;
          },
          child: SafeArea(
              top: false,
              bottom: false,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/main_background.png'),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: [
                    _playerSection(context),
                    // livePlayerProvider.player.isBuffering
                    livePlayerProvider.isBuffering != null &&
                            livePlayerProvider.isBuffering!
                        ? const VideoErrorAlert(
                            color: Colors.orange, message: "Buffering ...")
                        : const SizedBox.shrink(),
                    livePlayerProvider.playingState == FijkState.error
                        ? const VideoErrorAlert(
                            color: Colors.red, message: "Error!")
                        : const SizedBox.shrink(),
                    livePlayerProvider.playingState == FijkState.stopped
                        ? const VideoErrorAlert(message: "Stopped!")
                        : const SizedBox.shrink(),
                    livePlayerProvider.playingState == FijkState.asyncPreparing
                        ? const VideoErrorAlert(
                            color: Colors.green, message: "Connecting ...")
                        : const SizedBox.shrink(),
                    liveTvProvider.showMenu
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _categoriesListSection(context),
                              _liveChannelsListSection(context),
                            ],
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              )),
        ),
      ),
    );
  }

  // detects when a any physical key is pressed on the remote control
  void _onDKeyPressed(RawKeyEvent keyEvent, BuildContext context) {
    final liveTvProvider = context.read<LiveTvChannelsProvider>();

    liveTvProvider.havesDpadControl = true;

    if (keyEvent.runtimeType.toString() == 'RawKeyDownEvent') {
      if (keyEvent.logicalKey.debugName == 'Select') {
        liveTvProvider.showOrHideMainMenu();
        liveTvProvider.goBackCounter = 0;
      }
    }
  }

  // Categories list widget section
  Expanded _categoriesListSection(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/tvlogo.png",
                  height: screenSize.height * Constants.logoPercentHeight),
              SizedBox(
                width: screenSize.width * 0.02,
              ),
              const Text(
                "OhMyPlayer",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Expanded(
            child: ListView(
              // padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: screenSize.height * 0.03,
                ),
                ...context
                    .read<LiveTvChannelsProvider>()
                    .categoriesList
                    .map((category) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // reduce vertical spacing

                          // disabledBackgroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent),
                      // autofocus: true,
                      onFocusChange: (hasFocus) {
                        // useful when haves a physical remote control
                        if (hasFocus) {
                          context
                              .read<LiveTvChannelsProvider>()
                              .filterChannelsList(category);
                        }
                      },
                      onPressed: () {
                        context
                            .read<LiveTvChannelsProvider>()
                            .filterChannelsList(category);
                      },
                      child: Row(
                        children: [
                          // small dot next to the cagetory name
                          const CircleAvatar(
                              backgroundColor: Colors.white, radius: 2),
                          const SizedBox(width: 15),
                          Text(
                            category,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11.0),
                          ),
                        ],
                      ));
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // channels list widget section
  Expanded _liveChannelsListSection(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final liveTvProvider = context.read<LiveTvChannelsProvider>();
    final livePlayerProvider = context.read<LivePlayerProvider>();

    return Expanded(
      child: ListView(
        // padding: EdgeInsets.zero,
        children: [
          // this sizedbox needs to have the same size height of the logo
          // to avoid loosing focus when the user is scrolling
          SizedBox(
            height: screenSize.height * (Constants.logoPercentHeight - 0.04),
          ),
          SizedBox(
            height: screenSize.height * 0.03,
          ),
          ...context
              .read<LiveTvChannelsProvider>()
              .filteredChannelsList
              .map((channel) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize
                        .shrinkWrap, // reduce vertical spacing
                    backgroundColor: Colors.transparent),
                // play the video when the button is focused, after x time
                onFocusChange: (hasFocus) async {
                  if (hasFocus) {
                    await Future.delayed(const Duration(seconds: 3));
                    livePlayerProvider.playVideo(channel.url);
                  }
                },
                onPressed: () {
                  // livePlayerProvider.isInFullScreenMode = true;
                  // livePlayerProvider.playVideo(channel.url);
                  if (liveTvProvider.havesDpadControl) {
                    // livePlayerProvider.player.enterFullScreen();
                  } else {
                    liveTvProvider.showOrHideMainMenu();

                    livePlayerProvider.playVideo(channel.url);

                    // optional to send to the fullscreen page
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             LiveTvFullscreen(
                    //               url: channel.url,
                    //             )));
                  }

                  // context
                  //     .read<LiveTvProvider>()
                  //     .showOrHideMainMenu();
                  // fijkplayerProvider.playVideo(channel.url);
                },
                child: Row(
                  children: [
                    ChannelLogo(
                      channelLogo: channel.logo,
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: screenSize.width * 0.2,
                      child: MarqueeText(
                        text: channel.name,
                      ),
                    ),
                  ],
                ));
          }).toList(),
        ],
      ),
    );
  }

  // video player widget section
  _playerSection(BuildContext context) {
    final liveTvProvider = context.read<LiveTvChannelsProvider>();
    final livePlayerProvider = context.read<LivePlayerProvider>();

    return SizedBox.expand(
      child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPress: () async {
            // force to play the video again
            await livePlayerProvider.playVideo(livePlayerProvider.playingUrl);

            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.show(
                message: "Reloading", color: Colors.orange));
          },
          onVerticalDragUpdate: (details) {
            // print(details.delta.dy);

            if (details.delta.dy < -3) {
              // livePlayerProvider.videoPlayerController?.pause();
              // livePlayerProvider.isInFullScreenMode = true;

              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => LiveTvFullscreen(
              //           playingUrl: livePlayerProvider.playingUrl,
              //         )));
            }
          },
          onDoubleTap: () {
            livePlayerProvider.muteVideo();
          },
          onTap: () {
            liveTvProvider.showOrHideMainMenu();
          },
          child: IgnorePointer(
            ignoring: true,
            child: FijkView(
              player: livePlayerProvider.player,
              fit: FijkFit.fitHeight, // play with this other parameter
            ),
          )),
    );
  }
}
