import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/entities.dart';
part 'user_api.chopper.dart';

/// {@category Comunicação com a API}
/// Define as requisições que são feitas para a api relacionadas a usuário.
@ChopperApi(baseUrl: "/users")
abstract class UserApi extends ChopperService {
  /// Requisição GET de usuário, que trás informações do usuário do servidor.
  @Get(path: "")
  Future<Response<ApiUser>> getUser();

  /// Requisição POST de usuário, que cria um usuário no servidor, caso ele não exista.
  @Post(path: "")
  Future<Response<ApiUser>> postUser();

  /// Requisição DELETE de usuário, que deleta um usuário do servidor e seus baralhos.
  @Delete(path: "")
  Future<Response> deleteUser();

  /// Cria uma instância do serviço UserApi
  static UserApi create([ChopperClient? client]) => _$UserApi(client);
}
