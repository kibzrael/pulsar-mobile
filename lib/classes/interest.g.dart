// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Interest _$InterestFromJson(Map<String, dynamic> json) => Interest(
      name: json['name'] as String,
      user: json['user'] as String,
      users: json['users'] as String?,
      coverPhoto: json['coverPhoto'] == null
          ? null
          : Photo.fromJson(json['coverPhoto'] as Map<String, dynamic>),
      parent: json['parent'] == null
          ? null
          : Interest.fromJson(json['parent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InterestToJson(Interest instance) => <String, dynamic>{
      'name': instance.name,
      'users': instance.users,
      'user': instance.user,
      'coverPhoto': instance.coverPhoto?.toJson(),
      'parent': instance.parent?.toJson(),
    };
