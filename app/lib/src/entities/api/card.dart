import 'package:json_annotation/json_annotation.dart';
import '../local/deck/card.dart' as local;

part 'card.g.dart';

@JsonSerializable()
class Card {
  
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

  Card({this.id, this.frontText, this.frontImage, this.backText, this.backImage});

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  Map<String, dynamic> toJson() => _$CardToJson(this);

  local.Card toDomainModel() {
    return local.Card(
      id: id ?? "",
      frontImage: frontImage,
      frontText: frontText,
      backImage: backImage,
      backText: backText
    );
  }
}