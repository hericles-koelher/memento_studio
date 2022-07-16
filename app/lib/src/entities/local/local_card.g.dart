// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalCard _$LocalCardFromJson(Map<String, dynamic> json) => LocalCard(
      id: json['Id'] as String,
      frontText: json['FrontText'] as String?,
      frontImage: json['FrontImage'] as String?,
      backText: json['BackText'] as String?,
      backImage: json['BackImage'] as String?,
    );

Map<String, dynamic> _$LocalCardToJson(LocalCard instance) => <String, dynamic>{
      'Id': instance.id,
      'FrontText': instance.frontText,
      'FrontImage': instance.frontImage,
      'BackText': instance.backText,
      'BackImage': instance.backImage,
    };
