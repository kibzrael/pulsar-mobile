// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      dataSaver: json['dataSaver'] as bool? ?? false,
      requestTimeout: json['requestTimeout'] as int? ?? 15,
      mediaAutoplay:
          $enumDecodeNullable(_$AutoplayEnumMap, json['mediaAutoplay']) ??
              Autoplay.alwaysOn,
      mediaQuality:
          $enumDecodeNullable(_$MediaQualityEnumMap, json['mediaQuality']) ??
              MediaQuality.auto,
      searchHistory: (json['searchHistory'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'dataSaver': instance.dataSaver,
      'requestTimeout': instance.requestTimeout,
      'mediaAutoplay': _$AutoplayEnumMap[instance.mediaAutoplay],
      'mediaQuality': _$MediaQualityEnumMap[instance.mediaQuality],
      'searchHistory': instance.searchHistory,
    };

const _$AutoplayEnumMap = {
  Autoplay.alwaysOn: 'alwaysOn',
  Autoplay.wifiOnly: 'wifiOnly',
  Autoplay.off: 'off',
};

const _$MediaQualityEnumMap = {
  MediaQuality.auto: 'auto',
  MediaQuality.low: 'low',
  MediaQuality.medium: 'medium',
  MediaQuality.high: 'high',
};

Draft _$DraftFromJson(Map<String, dynamic> json) => Draft(
      json['video'] as String,
      filter: json['filter'] == null
          ? null
          : Filter.fromJson(json['filter'] as Map<String, dynamic>),
      audio: json['audio'] == null
          ? null
          : Audio.fromJson(json['audio'] as Map<String, dynamic>),
      thumbnail: (json['thumbnail'] as num?)?.toDouble() ?? 0.0,
      caption: json['caption'] as String?,
      challenge: json['challenge'] == null
          ? null
          : Challenge.fromJson(json['challenge'] as Map<String, dynamic>),
      location: json['location'] as bool? ?? true,
      rotate: json['rotate'] as int? ?? 0,
      camera: json['camera'] as bool?,
    );

Map<String, dynamic> _$DraftToJson(Draft instance) => <String, dynamic>{
      'video': instance.video,
      'camera': instance.camera,
      'filter': instance.filter?.toJson(),
      'audio': instance.audio?.toJson(),
      'thumbnail': instance.thumbnail,
      'caption': instance.caption,
      'challenge': instance.challenge?.toJson(),
      'location': instance.location,
      'rotate': instance.rotate,
    };
