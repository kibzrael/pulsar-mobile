// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Interest _$InterestFromJson(Map<String, dynamic> json) => Interest(
      name: json['name'] as String,
      category: json['category'] as String,
      pCategory: json['pCategory'] as String?,
      coverPhoto: json['coverPhoto'] == null
          ? null
          : Photo.fromJson(json['coverPhoto'] as Map<String, dynamic>),
      parent: json['parent'] == null
          ? null
          : Interest.fromJson(json['parent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InterestToJson(Interest instance) => <String, dynamic>{
      'name': instance.name,
      'pCategory': instance.pCategory,
      'category': instance.category,
      'coverPhoto': instance.coverPhoto,
      'parent': instance.parent,
    };
