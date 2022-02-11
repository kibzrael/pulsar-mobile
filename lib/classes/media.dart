import 'package:json_annotation/json_annotation.dart';

part 'media.g.dart';

@JsonSerializable()
class Photo {
  String thumbnail;
  String? medium;
  String? high;

  // change to source and get resolution
  String get photo => thumbnail;

  Photo({required this.thumbnail, this.medium, this.high});

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}

@JsonSerializable()
class Video {
  String small;
  String? medium;
  String? high;

  // change to source and get resolution
  String get video => small;

  Video({required this.small, this.medium, this.high});

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}
