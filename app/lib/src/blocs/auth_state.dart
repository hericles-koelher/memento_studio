part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class Unknown extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthenticationLoading extends Unauthenticated {}

class AuthenticationError extends Unauthenticated {
  final MSAuthException exception;

  AuthenticationError(this.exception);
}

class Authenticated extends AuthState {
  final ms_entities.User user;

  Authenticated(this.user);
}

class LogoutLoading extends Authenticated {
  LogoutLoading(ms_entities.User user) : super(user);
}

class AccountDeletionError extends Authenticated {
  final MSAuthException exception;

  AccountDeletionError(ms_entities.User user, this.exception) : super(user);
}

class AccountDeletionLoading extends Authenticated {
  AccountDeletionLoading(ms_entities.User user) : super(user);
}
