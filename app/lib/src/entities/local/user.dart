import 'package:memento_studio/src/entities.dart';

// TODO: Adicionar "Copy With"
class User {
  final String id;
  final String? name;
  final String token;
  final CredentialProvider provider;

  User({
    required this.id,
    required this.name,
    required this.token,
    required this.provider,
  });
}
