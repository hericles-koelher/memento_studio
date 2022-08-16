import 'package:memento_studio/src/exceptions.dart';

/// {@category Exceptions}
/// Tipos de código de exceção em uma [MSStorageException]
enum MSStorageExceptionCode {
  wrongId,
  deckNotFound,
}

/// {@category Exceptions}
/// Exceção de armazenamento local
class MSStorageException extends MSBaseException {
  final MSStorageExceptionCode code;

  MSStorageException({
    required String message,
    required this.code,
  }) : super(message: message);
}
