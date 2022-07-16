import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {

  @JsonKey(name: 'UUID')
  final String? id;

  @JsonKey(name: 'decks')
  final List<String>? decks;

  @JsonKey(name: 'lastSynchronization')
  final int? lastSynchronization;

  User({this.id, this.decks, this.lastSynchronization});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}