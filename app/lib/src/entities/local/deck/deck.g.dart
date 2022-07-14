// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeckCWProxy {
  Deck cards(List<Card> cards);

  Deck cover(String? cover);

  Deck description(String? description);

  Deck id(String id);

  Deck isPublic(bool isPublic);

  Deck lastModification(DateTime lastModification);

  Deck name(String name);

  Deck tags(List<String> tags);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Deck(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Deck(...).copyWith(id: 12, name: "My name")
  /// ````
  Deck call({
    List<Card>? cards,
    String? cover,
    String? description,
    String? id,
    bool? isPublic,
    DateTime? lastModification,
    String? name,
    List<String>? tags,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDeck.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDeck.copyWith.fieldName(...)`
class _$DeckCWProxyImpl implements _$DeckCWProxy {
  final Deck _value;

  const _$DeckCWProxyImpl(this._value);

  @override
  Deck cards(List<Card> cards) => this(cards: cards);

  @override
  Deck cover(String? cover) => this(cover: cover);

  @override
  Deck description(String? description) => this(description: description);

  @override
  Deck id(String id) => this(id: id);

  @override
  Deck isPublic(bool isPublic) => this(isPublic: isPublic);

  @override
  Deck lastModification(DateTime lastModification) =>
      this(lastModification: lastModification);

  @override
  Deck name(String name) => this(name: name);

  @override
  Deck tags(List<String> tags) => this(tags: tags);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Deck(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Deck(...).copyWith(id: 12, name: "My name")
  /// ````
  Deck call({
    Object? cards = const $CopyWithPlaceholder(),
    Object? cover = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? isPublic = const $CopyWithPlaceholder(),
    Object? lastModification = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
  }) {
    return Deck(
      cards: cards == const $CopyWithPlaceholder() || cards == null
          ? _value.cards
          // ignore: cast_nullable_to_non_nullable
          : cards as List<Card>,
      cover: cover == const $CopyWithPlaceholder()
          ? _value.cover
          // ignore: cast_nullable_to_non_nullable
          : cover as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      isPublic: isPublic == const $CopyWithPlaceholder() || isPublic == null
          ? _value.isPublic
          // ignore: cast_nullable_to_non_nullable
          : isPublic as bool,
      lastModification: lastModification == const $CopyWithPlaceholder() ||
              lastModification == null
          ? _value.lastModification
          // ignore: cast_nullable_to_non_nullable
          : lastModification as DateTime,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      tags: tags == const $CopyWithPlaceholder() || tags == null
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<String>,
    );
  }
}

extension $DeckCopyWith on Deck {
  /// Returns a callable class that can be used as follows: `instanceOfDeck.copyWith(...)` or like so:`instanceOfDeck.copyWith.fieldName(...)`.
  _$DeckCWProxy get copyWith => _$DeckCWProxyImpl(this);
}
