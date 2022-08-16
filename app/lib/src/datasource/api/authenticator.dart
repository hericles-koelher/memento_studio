import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/state_managers.dart';

/// {@category Comunicação com a API}
/// Intercepta uma requisição para adicionar o token do usuário.
class AuthRequestInterceptor extends RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    final authCubit = KiwiContainer().resolve<AuthCubit>();
    String token = authCubit.getToken() ?? ""; // Get token

    return applyHeader(request, 'Authorization', 'Bearer ' + token);
  }
}

/// {@category Comunicação com a API}
/// Trata caso de resposta de requisição com status code Unauthorized. Faz refresh token e
/// tenta 3 vezes reenviar a requisição.
class MSAuthenticator extends Authenticator {
  static const int MAX_ATTEMPTS = 3;
  static int attempts = 0;

  @override
  FutureOr<Request?> authenticate(Request request, Response response,
      [Request? originalRequest]) async {
    if (response.statusCode == 401 && attempts++ < MAX_ATTEMPTS) {
      // Refresh token
      final authCubit = KiwiContainer().resolve<AuthCubit>();
      await authCubit.refreshToken();

      String newToken = authCubit.getToken() ?? ""; // Get refreshed token

      final Map<String, String> updatedHeaders =
          Map<String, String>.of(request.headers);

      newToken = 'Bearer $newToken';
      updatedHeaders.update('Authorization', (String _) => newToken,
          ifAbsent: () => newToken);

      return request.copyWith(headers: updatedHeaders);
    }
    attempts = 0;

    return null;
  }
}
