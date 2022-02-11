// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Challenge _$ChallengeFromJson(Map<String, dynamic> json) => Challenge(
      json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] == null
          ? null
          : Interest.fromJson(json['category'] as Map<String, dynamic>),
      coverPhoto: Photo.fromJson(json['coverPhoto'] as Map<String, dynamic>),
      timeCreated: json['timeCreated'] == null
          ? null
          : DateTime.parse(json['timeCreated'] as String),
    );

Map<String, dynamic> _$ChallengeToJson(Challenge instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'description': instance.description,
      'coverPhoto': instance.coverPhoto,
      'timeCreated': instance.timeCreated?.toIso8601String(),
    };
