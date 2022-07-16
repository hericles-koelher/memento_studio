import '../datasource/api/user_api.dart';
import '../entities/api/user.dart';
import '../entities/local/result.dart';
import 'interfaces/user_repository_interface.dart';

class UserRepository extends UserRepositoryInterface {
  UserApi api;

  UserRepository(this.api);

  Future<Result<User>> getUser() async {
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

  Future<Result<User>> createUser() async {
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

