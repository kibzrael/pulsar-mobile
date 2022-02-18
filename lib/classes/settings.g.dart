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
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'dataSaver': instance.dataSaver,
      'requestTimeout': instance.requestTimeout,
      'mediaAutoplay': _$AutoplayEnumMap[instance.mediaAutoplay],
      'mediaQuality': _$MediaQualityEnumMap[instance.mediaQuality],
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
