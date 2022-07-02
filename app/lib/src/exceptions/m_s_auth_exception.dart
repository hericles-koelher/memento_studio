import 'package:memento_studio/src/exceptions.dart';

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
  unknown,
}

class MSAuthException extends MSBaseException {
  final MSAuthExceptionCode code;

  MSAuthException({
    required String message,
    required this.code,
  }) : super(message: message);
}
