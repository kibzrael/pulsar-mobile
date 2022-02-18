import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings {
  bool dataSaver;
  int requestTimeout;
  Autoplay mediaAutoplay;
  MediaQuality mediaQuality;

  Settings(
      {this.dataSaver = false,
      this.requestTimeout = 15,
      this.mediaAutoplay = Autoplay.alwaysOn,
      this.mediaQuality = MediaQuality.auto});

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}

enum Autoplay { alwaysOn, wifiOnly, off }

enum MediaQuality { auto, low, medium, high }
