import 'package:json_annotation/json_annotation.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/classes/user.dart';

part 'activity.g.dart';

@JsonSerializable()
class InteractionActivity {
  int id;
  User user;
  DateTime time;
  String? description;
  Photo? media;
  String? link;
  Interaction type;

  bool read;

  InteractionActivity(
      {required this.id,
      required this.user,
      required this.time,
      required this.type,
      this.description,
      this.media,
      this.link,
      this.read = false});

  factory InteractionActivity.fromJson(Map<String, dynamic> json) =>
      _$InteractionActivityFromJson(json);
  Map<String, dynamic> toJson() => _$InteractionActivityToJson(this);
}

enum Interaction { follow, like, comment, repost, notification }

Map<String, String> interactionLabels = {
  'follow': 'Followers',
  'like': 'Likes',
  'comment': 'Comments',
  'repost': 'Reposts',
  'notification': 'Post Notifications'
};
