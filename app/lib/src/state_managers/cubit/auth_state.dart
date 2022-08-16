part of 'auth_cubit.dart';

/// {@category Gerenciamento de estado}
/// Estados de autenticação
@immutable
abstract class AuthState {}

/// {@category Gerenciamento de estado}
class Unknown extends AuthState {}

/// {@category Gerenciamento de estado}
class Unauthenticated extends AuthState {}

/// {@category Gerenciamento de estado}
class AuthenticationLoading extends Unauthenticated {}

/// {@category Gerenciamento de estado}
class AuthenticationError extends Unauthenticated {
  final MSAuthException exception;

  AuthenticationError(this.exception);
}

/// {@category Gerenciamento de estado}
class Authenticated extends AuthState {
  final ms_entities.User user;

  Authenticated(this.user);
}

/// {@category Gerenciamento de estado}
class LogoutLoading extends Authenticated {
  LogoutLoading(ms_entities.User user) : super(user);
}

/// {@category Gerenciamento de estado}
class AccountDeletionError extends Authenticated {
  final MSAuthException exception;

  AccountDeletionError(ms_entities.User user, this.exception) : super(user);
}

class AccountDeletionLoading extends Authenticated {
  AccountDeletionLoading(ms_entities.User user) : super(user);
}
