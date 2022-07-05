import 'package:memento_studio/src/exceptions.dart';

// TODO: Ajustar esses códigos aqui...
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

class MSAuthException extends MSBaseException {
  final MSAuthExceptionCode code;

  MSAuthException({
    required String message,
    required this.code,
  }) : super(message: message);
}
