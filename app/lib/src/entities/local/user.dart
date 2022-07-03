import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:memento_studio/src/entities.dart';

part 'user.g.dart';

@CopyWith()
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
