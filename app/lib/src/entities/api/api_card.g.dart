// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiCard _$ApiCardFromJson(Map<String, dynamic> json) => ApiCard(
      id: json['uuid'] as String?,
      frontText: json['frontText'] as String?,
      frontImage: json['frontImagePath'] as String?,
      backText: json['backText'] as String?,
      backImage: json['backImagePath'] as String?,
    );

Map<String, dynamic> _$ApiCardToJson(ApiCard instance) => <String, dynamic>{
      'uuid': instance.id,
      'frontText': instance.frontText,
      'frontImagePath': instance.frontImage,
      'backText': instance.backText,
      'backImagePath': instance.backImage,
    };
