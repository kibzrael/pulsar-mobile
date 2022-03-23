import 'package:json_annotation/json_annotation.dart';
import 'package:pulsar/classes/media.dart';

part 'interest.g.dart';

@JsonSerializable(explicitToJson: true)
class Interest {
  String name;
  String? users;
  String user;
  Photo? coverPhoto;

  Interest? parent;

  Interest({
    required this.name,
    required this.user,
    this.users,
    this.coverPhoto,
    this.parent,
  });

  factory Interest.fromJson(Map<String, dynamic> json) =>
      _$InterestFromJson(json);
  Map<String, dynamic> toJson() => _$InterestToJson(this);
}
