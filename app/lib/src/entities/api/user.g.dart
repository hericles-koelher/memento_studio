// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['UUID'] as String?,
      decks:
          (json['decks'] as List<dynamic>?)?.map((e) => e as String).toList(),
      lastSynchronization: json['lastSynchronization'] as int?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'UUID': instance.id,
      'decks': instance.decks,
      'lastSynchronization': instance.lastSynchronization,
    };
