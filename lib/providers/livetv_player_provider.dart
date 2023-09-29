import 'dart:async';

import 'package:ohmyplayer/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';

class LivePlayerProvider extends ChangeNotifier {
  FijkPlayer player = FijkPlayer();

  bool isPlaying = false;

  bool? isBuffering;

  bool isInFullScreenMode = false;

  String videoDataSource = '';

  String playingUrl = '';

  bool isMuted = false;

  FijkState? playingState;

  LivePlayerProvider() {
    // playVideo(videoDataSource);
    // isPlaying = true;

    // player.onBufferPercentUpdate.listen((percent) async {
    //   print('buffering: $percent');

    //   if (percent > 500) {
    //     await player.reset();
    //     await player.setDataSource(playingUrl, autoPlay: true);
    //   }
    // });

    // player.onBufferStateUpdate.listen((bufferState) {
    //   print('isBuffering: $bufferState');
    // });

    // periodicReleasePlayer();
  }

  // void periodicReleasePlayer() {
  //   Timer.periodic(Duration(seconds: 30), (timer) async {
  //     await player.release();
  //     isPlaying = false;

  //     player = FijkPlayer();
  //     await playVideo(playingUrl);
  //   });
  // }

  // resets the player and Play a new video
  Future<void> playVideo(String videoDataSource) async {
    if (isPlaying) {
      await player.reset();
    }

    playingUrl = videoDataSource;

    if (videoDataSource.isNotEmpty) {
      await player.setDataSource(videoDataSource, autoPlay: true);
    }

    if (!isPlaying) {
      //only notify if the player is not playing
      isPlaying = true;
      notifyListeners();
    }
  }

  void muteVideo() {
    isMuted = !isMuted;
    isMuted ? player.setVolume(0) : player.setVolume(1);
  }

  // validate if the player detects an stream error or end, then reboot the stream
  void checkStreamState() async {
    playingState = player.state;

    // print(player.state.toString());
    // FijkState.asyncPreparing
    // if (player.state == FijkState.error ||
    //     player.state == FijkState.end ||
    //     player.state == FijkState.completed) {
    if (playingState == FijkState.end || playingState == FijkState.completed) {
      await Future.delayed(const Duration(
          seconds: Constants.qtyOfSecondsForStreamValidationStatus - 1));
      await playVideo(playingUrl);
    }

    // check if its buffering and show the buffering indicator
    if (isBuffering != player.isBuffering &&
        playingState == FijkState.started) {
      if (player.isBuffering == true) {
        isBuffering = true;

        notifyListeners();
      } else {
        isBuffering = false;

        notifyListeners();
      }
    }

    // useful on streams for fix the buffering issue, that the live videos gets so slow
    // if (player.bufferPercent > 1000) {
    //   await playVideo(playingUrl);
    // }
  }

  // check the stream state every X seconds
  void checkPeriodicStreamState(qtyOfSecondsForStreamValidationStatus) {
    Timer.periodic(Duration(seconds: qtyOfSecondsForStreamValidationStatus),
        (timer) {
      // print(
      //     "Player state ${player.state} y buffer percent ${player.bufferPercent}");
      checkStreamState();
    });
  }
}
