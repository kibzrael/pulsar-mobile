// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      json['id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      post: json['post'] as int,
      comment: json['comment'] as String,
      likes: json['likes'] as int? ?? 0,
      replies: json['replies'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      time: DateTime.parse(json['time'] as String),
    )..replyTo = json['reply_to'] as int?;

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user.toJson(),
      'post': instance.post,
      'comment': instance.comment,
      'time': instance.time.toIso8601String(),
      'reply_to': instance.replyTo,
      'likes': instance.likes,
      'replies': instance.replies,
      'is_liked': instance.isLiked,
    };
