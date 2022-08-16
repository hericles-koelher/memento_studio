import 'package:memento_studio/src/apis.dart';
import 'package:memento_studio/src/entities.dart';
import 'interfaces/user_repository_interface.dart';

/// {@category Repositórios}
/// Repositório da api de usuário.
class UserRepository extends UserRepositoryInterface {
  // Serviço do tipo UserApi
  UserApi api;

  UserRepository(this.api);

  /// Lê usuário e trata a resposta da api, convertendo para um modelo do core da aplicação, encapsulado em um [Result]
  @override
  Future<Result<ApiUser>> getUser() async {
    final response = await api.getUser();

    // Trata resposta
    if (!response.isSuccessful) {
      return Error(Exception(response.error.toString()));
    } else {
      if (response.body == null) {
        return Error(Exception("Could not parse response body"));
      }

      return Success(response.body!);
    }
  }

  /// Cria usuário e trata a resposta da api, convertendo para um modelo do core da aplicação, encapsulado em um [Result]
  @override
  Future<Result<ApiUser>> createUser() async {
    final response = await api.postUser();

    // Trata resposta
    if (!response.isSuccessful) {
      return Error(Exception(response.error.toString()));
    } else {
      if (response.body == null) {
        return Error(Exception("Could not parse response body"));
      }

      return Success(response.body!);
    }
  }

  /// Deleta usuário e trata a resposta da api, convertendo para um modelo do core da aplicação, encapsulado a um [Result]
  @override
  Future<Result> deleteUser() async {
    final response = await api.deleteUser();

    // Trata resposta
    if (!response.isSuccessful) {
      return Error(Exception(response.body));
    } else {
      return Success(response.body);
    }
  }
}
