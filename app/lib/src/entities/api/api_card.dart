import 'package:json_annotation/json_annotation.dart';
import 'package:memento_studio/src/entities.dart';

part 'api_card.g.dart';

/// {@category Entidades}
/// Modelo de carta recebido pela API
@JsonSerializable()
class ApiCard {
  @JsonKey(name: 'uuid')
  String? id;

  @JsonKey(name: 'frontText')
  String? frontText;

  @JsonKey(name: 'frontImagePath')
  String? frontImage;

  @JsonKey(name: 'backText')
  String? backText;

  @JsonKey(name: 'backImagePath')
  String? backImage;

  ApiCard(
      {this.id,
      this.frontText,
      this.frontImage,
      this.backText,
      this.backImage});

  factory ApiCard.fromJson(Map<String, dynamic> json) =>
      _$ApiCardFromJson(json);

  Map<String, dynamic> toJson() => _$ApiCardToJson(this);

  Card toDomainModel() {
    return Card(
        id: id ?? "",
        frontImage: frontImage,
        frontText: frontText,
        backImage: backImage,
        backText: backText);
  }
}
