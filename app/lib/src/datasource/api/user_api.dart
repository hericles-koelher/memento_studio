import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/entities.dart';
part 'user_api.chopper.dart';

@ChopperApi(baseUrl: "/users")
abstract class UserApi extends ChopperService {
  @Get(path: "")
  Future<Response<ApiUser>> getUser();

  @Post(path: "")
  Future<Response<ApiUser>> postUser();

  @Delete(path: "")
  Future<Response> deleteUser();

  static UserApi create([ChopperClient? client]) => _$UserApi(client);
}
