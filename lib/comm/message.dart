import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

//flutter packages pub run build_runner build --delete-conflicting-outputs

Config currentConfig = Config();
int id = 0;
bool firstLaunch = false;

@JsonSerializable()
class Config {
  // soit toute le monde soit l'adresse MAC de la tablette visée.
  //String target = "all";

  late String playerName;
  late String level;
  late String? friendName;

  Config({this.playerName = "Mask Dude", this.level = "Level 01", this.friendName});

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
