part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class Unknown extends AuthState {}

class Loading extends Unknown {}

class Unautheticated extends AuthState {}

class AuthenticationError extends Unautheticated {
  final MSAuthException exception;

  AuthenticationError(this.exception);
}

class Autheticated extends AuthState {
  final ms_entities.User user;

  Autheticated(this.user);
}

class AccountDeletionError extends Autheticated {
  final MSAuthException exception;

  AccountDeletionError(ms_entities.User user, this.exception) : super(user);
}
