// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      json['id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      source: Video.fromJson(json['source'] as Map<String, dynamic>),
      thumbnail: Photo.fromJson(json['thumbnail'] as Map<String, dynamic>),
      challenge: json['challenge'] == null
          ? null
          : Challenge.fromJson(json['challenge'] as Map<String, dynamic>),
      allowComments: json['allow_comments'] as bool? ?? true,
      caption: json['caption'] as String?,
      isLiked: json['is_liked'] as bool? ?? false,
      isReposted: json['is_reposted'] as bool? ?? false,
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      reposts: json['reposts'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      mentions: (json['mentions'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      filter: json['filter_name'] as String?,
      ratio: (json['ratio'] as num?)?.toDouble(),
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user.toJson(),
      'source': instance.source.toJson(),
      'thumbnail': instance.thumbnail.toJson(),
      'caption': instance.caption,
      'challenge': instance.challenge?.toJson(),
      'allow_comments': instance.allowComments,
      'likes': instance.likes,
      'comments': instance.comments,
      'reposts': instance.reposts,
      'points': instance.points,
      'time': instance.time?.toIso8601String(),
      'is_liked': instance.isLiked,
      'is_reposted': instance.isReposted,
      'filter_name': instance.filter,
      'ratio': instance.ratio,
      'tags': instance.tags,
      'mentions': instance.mentions.map((e) => e.toJson()).toList(),
    };
