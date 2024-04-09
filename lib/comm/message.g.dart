// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      playerName: json['characterPlayer1'] as String? ?? "Mask Dude",
      level: json['level'] as String? ?? "Level 01",
      friendName: json['characterPlayer2'] as String?,
    );

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'characterPlayer1': instance.playerName,
      'level': instance.level,
      'characterPlayer2': instance.friendName,
    };
