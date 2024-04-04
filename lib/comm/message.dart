import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

//flutter packages pub run build_runner build --delete-conflicting-outputs

Config currentConfig = Config();

@JsonSerializable()
class Config {
  // soit toute le monde soit l'adresse MAC de la tablette visée.
  //String target = "all";

  late String characterPlayer1;
  late String level;
  late String? characterPlayer2;

  Config({this.characterPlayer1 = "Mask Dude", this.level = "Level 01", this.characterPlayer2});

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
