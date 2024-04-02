import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

//flutter packages pub run build_runner build --delete-conflicting-outputs

@JsonSerializable()
class Config {
  // soit toute le monde soit l'adresse MAC de la tablette visée.
  String target = "all";

  final String characterPlayer1;
  final String level;
  final String? characterPlayer2;

  Config({required this.characterPlayer1, required this.level, this.characterPlayer2});

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
