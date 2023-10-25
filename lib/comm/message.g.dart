// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
    )..target = json['target'] as String;

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'target': instance.target,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
    };

SimonSequence _$SimonSequenceFromJson(Map<String, dynamic> json) =>
    SimonSequence()
      ..sequence =
          (json['sequence'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$SimonSequenceToJson(SimonSequence instance) =>
    <String, dynamic>{
      'sequence': instance.sequence,
    };
