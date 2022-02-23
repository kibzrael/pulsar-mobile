// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Audio _$AudioFromJson(Map<String, dynamic> json) => Audio(
      json['id'] as int,
      coverPhoto: Photo.fromJson(json['coverPhoto'] as Map<String, dynamic>),
      name: json['name'] as String,
      artist: json['artist'] as String,
    );

Map<String, dynamic> _$AudioToJson(Audio instance) => <String, dynamic>{
      'id': instance.id,
      'coverPhoto': instance.coverPhoto.toJson(),
      'name': instance.name,
      'artist': instance.artist,
    };

Filter _$FilterFromJson(Map<String, dynamic> json) => Filter(
      json['name'] as String,
      convolution: (json['convolution'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$FilterToJson(Filter instance) => <String, dynamic>{
      'name': instance.name,
      'convolution': instance.convolution,
    };
