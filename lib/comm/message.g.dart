// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      characterPlayer1: json['characterPlayer1'] as String,
      level: json['level'] as String,
      characterPlayer2: json['characterPlayer2'] as String?,
    )..target = json['target'] as String;

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'target': instance.target,
      'characterPlayer1': instance.characterPlayer1,
      'level': instance.level,
      'characterPlayer2': instance.characterPlayer2,
    };
