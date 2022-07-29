// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$UserApi extends UserApi {
  _$UserApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = UserApi;

  @override
  Future<Response<ApiUser>> getUser() {
    final $url = '/users';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<ApiUser, ApiUser>($request);
  }

  @override
  Future<Response<ApiUser>> postUser() {
    final $url = '/users';
    final $request = Request('POST', $url, client.baseUrl);
    return client.send<ApiUser, ApiUser>($request);
  }

  @override
  Future<Response<dynamic>> deleteUser() {
    final $url = '/users';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
