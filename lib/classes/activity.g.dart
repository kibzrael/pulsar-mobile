// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InteractionActivity _$InteractionActivityFromJson(Map<String, dynamic> json) =>
    InteractionActivity(
      id: json['id'] as String,
      userId: json['userId'] as int,
      username: json['username'] as String,
      time: DateTime.parse(json['time'] as String),
      type: $enumDecode(_$InteractionEnumMap, json['type']),
      thumbnail: json['thumbnail'] as String?,
      description: json['description'] as String?,
      media: json['media'] as String?,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$InteractionActivityToJson(
        InteractionActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'username': instance.username,
      'time': instance.time.toIso8601String(),
      'thumbnail': instance.thumbnail,
      'description': instance.description,
      'media': instance.media,
      'link': instance.link,
      'type': _$InteractionEnumMap[instance.type],
    };

const _$InteractionEnumMap = {
  Interaction.follow: 'follow',
  Interaction.like: 'like',
  Interaction.comment: 'comment',
  Interaction.repost: 'repost',
  Interaction.notification: 'notification',
};
