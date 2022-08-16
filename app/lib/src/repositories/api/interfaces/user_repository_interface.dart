/// {@category Repositórios}
/// Interface do repositório da api de usuário.
abstract class UserRepositoryInterface {
  dynamic getUser();

  dynamic createUser();

  dynamic deleteUser();
}
