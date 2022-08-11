// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_deck_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiDeckReference _$ApiDeckReferenceFromJson(Map<String, dynamic> json) =>
    ApiDeckReference(
      id: json['UUID'] as String,
      description: json['Description'] as String? ?? "",
      cover: json['Cover'] as String? ?? "",
      name: json['Name'] as String? ?? "",
      tags:
          (json['Tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      author: json['Author'] as String? ?? "",
      numberOfCards: json['NumberOfCards'] as int? ?? 0,
    );

Map<String, dynamic> _$ApiDeckReferenceToJson(ApiDeckReference instance) =>
    <String, dynamic>{
      'UUID': instance.id,
      'Description': instance.description,
      'Cover': instance.cover,
      'Name': instance.name,
      'Tags': instance.tags,
      'Author': instance.author,
      'NumberOfCards': instance.numberOfCards,
    };
