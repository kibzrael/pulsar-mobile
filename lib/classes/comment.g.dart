// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      json['id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      post: Post.fromJson(json['post'] as Map<String, dynamic>),
      comment: json['comment'] as String,
      likes: json['likes'] as int? ?? 0,
      replies: json['replies'] as int? ?? 0,
      time: DateTime.parse(json['time'] as String),
    )..replyTo = json['replyTo'] == null
        ? null
        : Comment.fromJson(json['replyTo'] as Map<String, dynamic>);

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user.toJson(),
      'post': instance.post.toJson(),
      'comment': instance.comment,
      'time': instance.time.toIso8601String(),
      'replyTo': instance.replyTo?.toJson(),
      'likes': instance.likes,
      'replies': instance.replies,
    };
