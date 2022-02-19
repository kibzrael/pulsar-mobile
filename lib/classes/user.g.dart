// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      username: json['username'] as String,
      category: json['category'] as String?,
      bio: json['bio'] as String?,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      email: json['email'] as String?,
      fullname: json['fullname'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => Interest.fromJson(e as Map<String, dynamic>))
          .toList(),
      isBlocked: json['isBlocked'] as bool?,
      isFollowing: json['is_following'] as bool?,
      phone: json['phone'] as String?,
      followers: json['followers'] as int?,
      portfolio: json['portfolio'] as String?,
      posts: json['posts'] as int?,
      profilePic: json['profile_pic'] == null
          ? null
          : Photo.fromJson(json['profile_pic'] as Map<String, dynamic>),
      isSuperuser: json['is_superuser'] as bool? ?? false,
    )
      ..token = json['jwtToken'] as String?
      ..postNotifications = json['postNotifications'] as bool?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'category': instance.category,
      'fullname': instance.fullname,
      'profile_pic': instance.profilePic?.toJson(),
      'bio': instance.bio,
      'portfolio': instance.portfolio,
      'interests': instance.interests?.map((e) => e.toJson()).toList(),
      'email': instance.email,
      'phone': instance.phone,
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'is_superuser': instance.isSuperuser,
      'jwtToken': instance.token,
      'followers': instance.followers,
      'posts': instance.posts,
      'is_following': instance.isFollowing,
      'isBlocked': instance.isBlocked,
      'postNotifications': instance.postNotifications,
    };
