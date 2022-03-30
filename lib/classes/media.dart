import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/connectivity_provider.dart';

part 'media.g.dart';

@JsonSerializable(explicitToJson: true)
class Photo {
  String thumbnail;
  String? medium;
  String? high;

  // change to source and get resolution
  String photo(BuildContext context, {String max = 'high'}) {
    Resolution resolution =
        Provider.of<ConnectivityProvider>(context, listen: false).resolution;
    debugPrint(Provider.of<ConnectivityProvider>(context, listen: false)
        .dataSaver
        .toString());

    String result = resolution == Resolution.low
        ? thumbnail
        : resolution == Resolution.medium
            ? medium ?? thumbnail
            : high ?? medium ?? thumbnail;

    return max == 'thumbnail'
        ? thumbnail
        : max == 'medium' && result == 'high'
            ? medium ?? thumbnail
            : result;
  }

  Photo({required this.thumbnail, this.medium, this.high});

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Video {
  String low;
  String? medium;
  String? high;

  // change to source and get resolution
  String video(BuildContext context) {
    Resolution resolution =
        Provider.of<ConnectivityProvider>(context, listen: false).resolution;
    return resolution == Resolution.low
        ? low
        : resolution == Resolution.medium
            ? medium ?? low
            : medium ?? low;
    // : high ?? medium ?? low;
  }

  Video({required this.low, this.medium, this.high});

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}
