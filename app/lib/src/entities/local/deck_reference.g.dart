// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_reference.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeckReferenceCWProxy {
  DeckReference author(String? author);

  DeckReference cover(String? cover);

  DeckReference description(String? description);

  DeckReference id(String id);

  DeckReference name(String name);

  DeckReference numberOfCards(int numberOfCards);

  DeckReference tags(List<String> tags);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeckReference(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeckReference(...).copyWith(id: 12, name: "My name")
  /// ````
  DeckReference call({
    String? author,
    String? cover,
    String? description,
    String? id,
    String? name,
    int? numberOfCards,
    List<String>? tags,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDeckReference.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDeckReference.copyWith.fieldName(...)`
class _$DeckReferenceCWProxyImpl implements _$DeckReferenceCWProxy {
  final DeckReference _value;

  const _$DeckReferenceCWProxyImpl(this._value);

  @override
  DeckReference author(String? author) => this(author: author);

  @override
  DeckReference cover(String? cover) => this(cover: cover);

  @override
  DeckReference description(String? description) =>
      this(description: description);

  @override
  DeckReference id(String id) => this(id: id);

  @override
  DeckReference name(String name) => this(name: name);

  @override
  DeckReference numberOfCards(int numberOfCards) =>
      this(numberOfCards: numberOfCards);

  @override
  DeckReference tags(List<String> tags) => this(tags: tags);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeckReference(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeckReference(...).copyWith(id: 12, name: "My name")
  /// ````
  DeckReference call({
    Object? author = const $CopyWithPlaceholder(),
    Object? cover = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? numberOfCards = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
  }) {
    return DeckReference(
      author: author == const $CopyWithPlaceholder()
          ? _value.author
          // ignore: cast_nullable_to_non_nullable
          : author as String?,
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
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      numberOfCards:
          numberOfCards == const $CopyWithPlaceholder() || numberOfCards == null
              ? _value.numberOfCards
              // ignore: cast_nullable_to_non_nullable
              : numberOfCards as int,
      tags: tags == const $CopyWithPlaceholder() || tags == null
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<String>,
    );
  }
}

extension $DeckReferenceCopyWith on DeckReference {
  /// Returns a callable class that can be used as follows: `instanceOfDeckReference.copyWith(...)` or like so:`instanceOfDeckReference.copyWith.fieldName(...)`.
  _$DeckReferenceCWProxy get copyWith => _$DeckReferenceCWProxyImpl(this);
}
