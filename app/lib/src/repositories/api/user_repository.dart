import 'package:memento_studio/src/apis.dart';
import 'package:memento_studio/src/entities.dart';
import 'interfaces/user_repository_interface.dart';

class UserRepository extends UserRepositoryInterface {
  UserApi api;

  UserRepository(this.api);

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
