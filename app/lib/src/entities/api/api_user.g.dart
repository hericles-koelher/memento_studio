// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiUser _$ApiUserFromJson(Map<String, dynamic> json) => ApiUser(
      id: json['UUID'] as String?,
      decks:
          (json['decks'] as List<dynamic>?)?.map((e) => e as String).toList(),
      lastSynchronization: json['lastSynchronization'] as int?,
    );

Map<String, dynamic> _$ApiUserToJson(ApiUser instance) => <String, dynamic>{
      'UUID': instance.id,
      'decks': instance.decks,
      'lastSynchronization': instance.lastSynchronization,
    };
