// To parse this JSON data, do
//
//     final liveChannel = liveChannelFromJson(jsonString);

import 'dart:convert';

// liveChannelFromJson(String str) => print(json.decode(str));

List<LiveChannel> liveChannelFromJson(String str) => List<LiveChannel>.from(
    json.decode(str).map((x) => LiveChannel.fromJson(x)));

class LiveChannel {
  String name;
  String logo;
  String group;
  String url;

  LiveChannel({
    required this.name,
    required this.logo,
    required this.group,
    required this.url,
  });

  factory LiveChannel.fromJson(Map<String, dynamic> json) => LiveChannel(
        name: json["name"],
        logo: json["logo"],
        group: json["group"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "logo": logo,
        "group": group,
        "url": url,
      };
}
