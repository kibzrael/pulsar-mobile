import 'package:json_annotation/json_annotation.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/post/post_provider.dart';

part 'settings.g.dart';

@JsonSerializable(explicitToJson: true)
class Settings {
  bool dataSaver;
  int requestTimeout;
  Autoplay mediaAutoplay;
  MediaQuality mediaQuality;

  List<String> searchHistory;
  List<Draft> drafts;

  Settings({
    this.dataSaver = false,
    this.requestTimeout = 15,
    this.mediaAutoplay = Autoplay.alwaysOn,
    this.mediaQuality = MediaQuality.auto,
    this.searchHistory = const [],
    this.drafts = const [],
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}

enum Autoplay { alwaysOn, wifiOnly, off }

enum MediaQuality { auto, low, medium, high }

@JsonSerializable(explicitToJson: true)
class Draft {
  String video;

  bool? camera;

  Filter? filter;

  Audio? audio;

  double thumbnail;

  String? caption;

  Challenge? challenge;

  bool location;

  int rotate;

  Draft(this.video,
      {this.filter,
      this.audio,
      this.thumbnail = 0.0,
      this.caption,
      this.challenge,
      this.location = true,
      this.rotate = 0,
      this.camera});

  factory Draft.fromJson(Map<String, dynamic> json) => _$DraftFromJson(json);
  Map<String, dynamic> toJson() => _$DraftToJson(this);
}
