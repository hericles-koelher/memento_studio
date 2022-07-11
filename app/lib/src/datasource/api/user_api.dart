import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/entities/api/user.dart';
part 'user_api.chopper.dart';

@ChopperApi(baseUrl: "/users")
abstract class UserApi extends ChopperService {

  @Get(path: "")
  Future<Response<User>> getUser();

  @Post(path: "")
  Future<Response<User>> postUser();

  @Delete(path: "")
  Future<Response> deleteUser();

  static UserApi create([ChopperClient? client]) => _$UserApi(client);
}