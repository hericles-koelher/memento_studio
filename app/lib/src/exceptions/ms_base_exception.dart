/// {@category Exceptions}
/// Base de uma exceção da aplicação
abstract class MSBaseException implements Exception {
  final String message;

  MSBaseException({required this.message});
}
