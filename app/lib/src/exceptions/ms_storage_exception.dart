import 'package:memento_studio/src/exceptions.dart';

enum MSStorageExceptionCode {
  wrongId,
  deckNotFound,
}

class MSStorageException extends MSBaseException {
  final MSStorageExceptionCode code;

  MSStorageException({
    required String message,
    required this.code,
  }) : super(message: message);
}
