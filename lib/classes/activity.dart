import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable()
class InteractionActivity {
  String id;
  int userId;
  String username;
  DateTime time;
  String? thumbnail;
  String? description;
  String? media;
  String? link;
  Interaction type;

  InteractionActivity(
      {required this.id,
      required this.userId,
      required this.username,
      required this.time,
      required this.type,
      this.thumbnail,
      this.description,
      this.media,
      this.link});

  factory InteractionActivity.fromJson(Map<String, dynamic> json) =>
      _$InteractionActivityFromJson(json);
  Map<String, dynamic> toJson() => _$InteractionActivityToJson(this);
}

enum Interaction { follow, like, comment, repost, notification }
