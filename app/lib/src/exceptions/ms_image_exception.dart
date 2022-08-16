import 'package:memento_studio/src/exceptions.dart';

/// {@category Exceptions}
/// Exceção que pode ocorrer relacionada a imagens
class MSImageException extends MSBaseException {
  MSImageException({required String message}) : super(message: message);
}
