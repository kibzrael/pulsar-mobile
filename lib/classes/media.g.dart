// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      thumbnail: json['thumbnail'] as String,
      medium: json['medium'] as String?,
      high: json['high'] as String?,
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'medium': instance.medium,
      'high': instance.high,
    };

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      small: json['small'] as String,
      medium: json['medium'] as String?,
      high: json['high'] as String?,
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'small': instance.small,
      'medium': instance.medium,
      'high': instance.high,
    };
