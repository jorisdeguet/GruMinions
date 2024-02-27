import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Person {
  // soit toute le monde soit l'adresse MAC de la tablette visée.
  String target = "all";

  /// The generated code assumes these values exist in JSON.
  final String firstName, lastName;

  /// The generated code below handles if the corresponding JSON value doesn't
  /// exist or is empty.
  final DateTime? dateOfBirth;

  Person({required this.firstName, required this.lastName, this.dateOfBirth});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializable()
class SimonSequence {
  // soit toute le monde soit l'adresse MAC de la tablette visée.
  List<String> sequence = [];

  SimonSequence();

  factory SimonSequence.fromJson(Map<String, dynamic> json) =>
      _$SimonSequenceFromJson(json);

  Map<String, dynamic> toJson() => _$SimonSequenceToJson(this);
}
