// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CardCWProxy {
  Card backImage(String? backImage);

  Card backText(String? backText);

  Card frontImage(String? frontImage);

  Card frontText(String? frontText);

  Card id(String id);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Card(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Card(...).copyWith(id: 12, name: "My name")
  /// ````
  Card call({
    String? backImage,
    String? backText,
    String? frontImage,
    String? frontText,
    String? id,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCard.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCard.copyWith.fieldName(...)`
class _$CardCWProxyImpl implements _$CardCWProxy {
  final Card _value;

  const _$CardCWProxyImpl(this._value);

  @override
  Card backImage(String? backImage) => this(backImage: backImage);

  @override
  Card backText(String? backText) => this(backText: backText);

  @override
  Card frontImage(String? frontImage) => this(frontImage: frontImage);

  @override
  Card frontText(String? frontText) => this(frontText: frontText);

  @override
  Card id(String id) => this(id: id);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Card(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Card(...).copyWith(id: 12, name: "My name")
  /// ````
  Card call({
    Object? backImage = const $CopyWithPlaceholder(),
    Object? backText = const $CopyWithPlaceholder(),
    Object? frontImage = const $CopyWithPlaceholder(),
    Object? frontText = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
  }) {
    return Card(
      backImage: backImage == const $CopyWithPlaceholder()
          ? _value.backImage
          // ignore: cast_nullable_to_non_nullable
          : backImage as String?,
      backText: backText == const $CopyWithPlaceholder()
          ? _value.backText
          // ignore: cast_nullable_to_non_nullable
          : backText as String?,
      frontImage: frontImage == const $CopyWithPlaceholder()
          ? _value.frontImage
          // ignore: cast_nullable_to_non_nullable
          : frontImage as String?,
      frontText: frontText == const $CopyWithPlaceholder()
          ? _value.frontText
          // ignore: cast_nullable_to_non_nullable
          : frontText as String?,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
    );
  }
}

extension $CardCopyWith on Card {
  /// Returns a callable class that can be used as follows: `instanceOfCard.copyWith(...)` or like so:`instanceOfCard.copyWith.fieldName(...)`.
  _$CardCWProxy get copyWith => _$CardCWProxyImpl(this);
}
