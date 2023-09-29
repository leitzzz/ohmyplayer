import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ohmyplayer/services/api_service.dart';
import 'package:ohmyplayer/config/constants.dart';
import 'package:ohmyplayer/models/live_channel.dart';

class LiveTvChannelsProvider extends ChangeNotifier {
  bool havesDpadControl =
      false; // helps to indicate if the device has dpad remote control

  bool _showMenu = false;
  bool get showMenu => _showMenu;

  int _goBackCounter = 0;
  int get goBackCounter => _goBackCounter;
  set goBackCounter(int value) => _goBackCounter = value;

  bool _isLoadingChannels = false;
  set isLoadingChannels(bool value) => _isLoadingChannels = value;
  bool get isLoadingChannels => _isLoadingChannels;

  List<LiveChannel> liveChannelsList = []; // list of LiveChannel objects

  List<String> categoriesList =
      []; // filtered categories, example "COLOMBIA", "CHILE", "SPAIN"
  List<LiveChannel> filteredChannelsList =
      []; // channels filtered for example by category

  String firstChannelUrl =
      ''; // save the first channel url to play, this is to play when the app is starting

  // hides or shows the main menu: categories and channels
  void showOrHideMainMenu() {
    _showMenu = !_showMenu;

    notifyListeners();
  }

  void incrementGoBackCounter() {
    _goBackCounter++;

    // resets the counter after X seconds
    Timer(const Duration(milliseconds: 1000), () {
      _goBackCounter = 0;
    });

    notifyListeners();
  }

  // connects to the api to retrieve the channels list, and parse to a models LiveChannel list
  Future<void> getLiveChannels() async {
    try {
      _isLoadingChannels = true;

      final response = await ApiService.request(Constants.defaultUrlStream);

      liveChannelsList = liveChannelFromJson(response);

      // different categories, to show in the main menu channels
      categoriesList =
          liveChannelsList.map((channel) => channel.group).toSet().toList();

      // if the channels list is empty, then filter by the default first category in the categories list
      if (filteredChannelsList.isEmpty) {
        filterChannelsList(
            categoriesList[0]); // by default filter by first category

        firstChannelUrl = liveChannelsList[0].url; // first channel url to play
      }

      _isLoadingChannels = false;

      notifyListeners();
    } catch (e) {
      // print(e);
    }
  }

  // filters the channels list by category
  void filterChannelsList(String category) {
    filteredChannelsList =
        liveChannelsList.where((channel) => channel.group == category).toList();
    // .map((filteredChannel) => filteredChannel)
    // .toList();

    notifyListeners();
  }
}
