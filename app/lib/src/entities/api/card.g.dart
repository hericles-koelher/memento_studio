// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) => Card(
      id: json['uuid'] as String?,
      frontText: json['frontText'] as String?,
      frontImage: json['frontImagePath'] as String?,
      backText: json['backText'] as String?,
      backImage: json['backImagePath'] as String?,
    );

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'uuid': instance.id,
      'frontText': instance.frontText,
      'frontImagePath': instance.frontImage,
      'backText': instance.backText,
      'backImagePath': instance.backImage,
    };
