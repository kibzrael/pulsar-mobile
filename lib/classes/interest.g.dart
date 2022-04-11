// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Interest _$InterestFromJson(Map<String, dynamic> json) => Interest(
      name: json['name'] as String,
      user: json['user'] as String,
      users: json['users'] as String?,
      cover: json['cover'] == null
          ? null
          : Photo.fromJson(json['cover'] as Map<String, dynamic>),
      parent: json['parent'] == null
          ? null
          : Interest.fromJson(json['parent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InterestToJson(Interest instance) => <String, dynamic>{
      'name': instance.name,
      'users': instance.users,
      'user': instance.user,
      'cover': instance.cover?.toJson(),
      'parent': instance.parent?.toJson(),
    };
