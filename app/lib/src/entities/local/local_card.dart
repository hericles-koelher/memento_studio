import 'package:json_annotation/json_annotation.dart';

part 'local_card.g.dart';

/// {@category Entidades}
/// Modelo de carta utilizado no armazenamento local
@JsonSerializable(fieldRename: FieldRename.pascal)
class LocalCard {
  final String id;
  final String? frontText;
  final String? frontImage;
  final String? backText;
  final String? backImage;

  LocalCard({
    required this.id,
    this.frontText,
    this.frontImage,
    this.backText,
    this.backImage,
  });

  factory LocalCard.fromJson(Map<String, dynamic> json) =>
      _$LocalCardFromJson(json);

  Map<String, dynamic> toJson() => _$LocalCardToJson(this);
}
