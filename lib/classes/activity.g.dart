// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InteractionActivity _$InteractionActivityFromJson(Map<String, dynamic> json) =>
    InteractionActivity(
      id: json['id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      time: DateTime.parse(json['time'] as String),
      type: $enumDecode(_$InteractionEnumMap, json['type']),
      description: json['description'] as String?,
      media: json['media'] == null
          ? null
          : Photo.fromJson(json['media'] as Map<String, dynamic>),
      link: json['link'] as String?,
      read: json['read'] as bool? ?? false,
    );

Map<String, dynamic> _$InteractionActivityToJson(
        InteractionActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'time': instance.time.toIso8601String(),
      'description': instance.description,
      'media': instance.media,
      'link': instance.link,
      'type': _$InteractionEnumMap[instance.type]!,
      'read': instance.read,
    };

const _$InteractionEnumMap = {
  Interaction.follow: 'follow',
  Interaction.like: 'like',
  Interaction.comment: 'comment',
  Interaction.repost: 'repost',
  Interaction.notification: 'notification',
};
