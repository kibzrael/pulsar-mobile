// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      username: json['username'] as String,
      category: json['category'] as String,
      bio: json['bio'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      email: json['email'] as String?,
      fullname: json['fullname'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => Interest.fromJson(e as Map<String, dynamic>))
          .toList(),
      isBlocked: json['isBlocked'] as bool?,
      isFollowing: json['isFollowing'] as bool?,
      phone: json['phone'] as String?,
      followers: json['followers'] as int?,
      portfolio: json['portfolio'] as String?,
      posts: json['posts'] as int?,
      profilePic: json['profilePic'] == null
          ? null
          : Photo.fromJson(json['profilePic'] as Map<String, dynamic>),
      isSuperuser: json['isSuperuser'] as bool? ?? false,
    )
      ..token = json['token'] as String?
      ..postNotifications = json['postNotifications'] as bool?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'category': instance.category,
      'fullname': instance.fullname,
      'profilePic': instance.profilePic,
      'bio': instance.bio,
      'portfolio': instance.portfolio,
      'interests': instance.interests,
      'email': instance.email,
      'phone': instance.phone,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'isSuperuser': instance.isSuperuser,
      'token': instance.token,
      'followers': instance.followers,
      'posts': instance.posts,
      'isFollowing': instance.isFollowing,
      'isBlocked': instance.isBlocked,
      'postNotifications': instance.postNotifications,
    };
