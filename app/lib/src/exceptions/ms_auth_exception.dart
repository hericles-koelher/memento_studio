import 'package:memento_studio/src/exceptions.dart';

/// {@category Exceptions}
/// Tipos de código de exceção em uma [MSAuthException]
enum MSAuthExceptionCode {
  invalidEmail,
  disableAccount,
  accountNotFound,
  wrongPassword,
  accountExistsWithDifferentCredential,
  emailAlreadyInUse,
  weakPassword,
  requiresRecentLogin,
  userMismatch,
  invalidCredentialType,
  unknown,
}

/// {@category Exceptions}
/// Exceção que pode ocorrer durante a autenticação
class MSAuthException extends MSBaseException {
  final MSAuthExceptionCode code;

  MSAuthException({
    required String message,
    required this.code,
  }) : super(message: message);
}
