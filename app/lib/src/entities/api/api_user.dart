import 'package:json_annotation/json_annotation.dart';

part 'api_user.g.dart';

@JsonSerializable()
class ApiUser {
  @JsonKey(name: 'UUID')
  final String? id;

  @JsonKey(name: 'decks')
  final List<String>? decks;

  @JsonKey(name: 'lastSynchronization')
  final int? lastSynchronization;

  ApiUser({this.id, this.decks, this.lastSynchronization});

  factory ApiUser.fromJson(Map<String, dynamic> json) =>
      _$ApiUserFromJson(json);

  Map<String, dynamic> toJson() => _$ApiUserToJson(this);
}
