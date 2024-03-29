// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_deck.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiDeck _$ApiDeckFromJson(Map<String, dynamic> json) => ApiDeck(
      id: json['UUID'] as String?,
      cards: (json['cards'] as List<dynamic>?)
          ?.map((e) => ApiCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      cover: json['cover'] as String?,
      name: json['name'] as String?,
      isPublic: json['isPublic'] as bool?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      lastModification: json['lastModification'] as int?,
    );

Map<String, dynamic> _$ApiDeckToJson(ApiDeck instance) => <String, dynamic>{
      'UUID': instance.id,
      'cards': instance.cards,
      'description': instance.description,
      'cover': instance.cover,
      'name': instance.name,
      'isPublic': instance.isPublic,
      'tags': instance.tags,
      'lastModification': instance.lastModification,
    };
