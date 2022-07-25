import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../exceptions.dart';
import '../../entities.dart' as ms_entities;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  StreamSubscription? _userStreamSubscription;

  AuthCubit()
      : _auth = FirebaseAuth.instance,
        super(Unknown()) {
    _listenToUserStream();
  }

  ms_entities.CredentialProvider? _getUserProvider() {
    String? providerId = _auth.currentUser?.providerData.first.providerId;

    if (EmailAuthProvider.PROVIDER_ID.compareTo(providerId ?? '') == 0) {
      return ms_entities.CredentialProvider.email;
    } else if (FacebookAuthProvider.PROVIDER_ID.compareTo(providerId ?? '') ==
        0) {
      return ms_entities.CredentialProvider.facebook;
    } else if (GoogleAuthProvider.PROVIDER_ID.compareTo(providerId ?? '') ==
        0) {
      return ms_entities.CredentialProvider.google;
    } else {
      return null;
    }
  }

  MSAuthException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        return MSAuthException(
          message: "E-mail inválido",
          code: MSAuthExceptionCode.invalidEmail,
        );
      case "user-disabled":
        return MSAuthException(
          message: "Conta desativada",
          code: MSAuthExceptionCode.disableAccount,
        );
      case "user-not-found":
        return MSAuthException(
          message: "Conta não encontrada",
          code: MSAuthExceptionCode.accountNotFound,
        );
      case "wrong-password":
        return MSAuthException(
          message: "E-mail e/ou senha incorreta",
          code: MSAuthExceptionCode.wrongPassword,
        );
      case "account-exists-with-different-credential":
        return MSAuthException(
          message: "Uma conta com este e-mail já existe",
          code: MSAuthExceptionCode.accountExistsWithDifferentCredential,
        );
      case "email-already-in-use":
        return MSAuthException(
          message: "Este e-mail já está em uso",
          code: MSAuthExceptionCode.emailAlreadyInUse,
        );
      case "weak-password":
        return MSAuthException(
          message: "A senha apresentada é muito fraca",
          code: MSAuthExceptionCode.weakPassword,
        );
      case "requires-recent-login":
        return MSAuthException(
          message: "Por favor, faça login novamente antes de efetuar esta ação",
          code: MSAuthExceptionCode.requiresRecentLogin,
        );
      case "user-mismatch":
        return MSAuthException(
          message: "Credenciais não correspondem com a conta em uso",
          code: MSAuthExceptionCode.userMismatch,
        );
      default:
        return MSAuthException(
          message: "Erro desconhecido: ${e.message}",
          code: MSAuthExceptionCode.unknown,
        );
    }
  }

  void _listenToUserStream() {
    _userStreamSubscription = _auth.userChanges().listen((User? user) async {
      if (user != null) {
        emit(
          Autheticated(
            ms_entities.User(
              id: user.uid,
              name: user.displayName,
              token: await user.getIdToken(),
              provider: _getUserProvider()!,
            ),
          ),
        );
      } else {
        emit(Unautheticated());
      }
    });
  }

  @override
  Future<void> close() {
    _userStreamSubscription?.cancel();

    return super.close();
  }

  Future<void> signOut() async {
    if (state is Autheticated) {
      emit(Loading());

      await _auth.signOut();
    }
  }

  Future<void> refreshToken() async {
    if (state is Autheticated) {
      emit(
        Autheticated(
          ms_entities.User(
            name: _auth.currentUser!.displayName,
            id: _auth.currentUser!.uid,
            token: await _auth.currentUser!.getIdToken(),
            provider: _getUserProvider()!,
          ),
        ),
      );
    }
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    if (state is Unautheticated) {
      try {
        emit(Loading());

        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        emit(AuthenticationError(_handleFirebaseAuthException(e)));
      }
    }
  }

  Future<void> signInWithCredential({
    required ms_entities.CredentialProvider provider,
    required String accessToken,
    String? idToken,
  }) async {
    if (state is Unautheticated) {
      try {
        emit(Loading());

        AuthCredential credential;

        switch (provider) {
          case ms_entities.CredentialProvider.facebook:
            credential = FacebookAuthProvider.credential(accessToken);
            break;
          case ms_entities.CredentialProvider.google:
            credential = GoogleAuthProvider.credential(
              accessToken: accessToken,
              idToken: idToken,
            );
            break;
          case ms_entities.CredentialProvider.email:
            emit(
              AuthenticationError(
                MSAuthException(
                  message: "Provedor de credenciais inválido para este método",
                  code: MSAuthExceptionCode.unknown,
                ),
              ),
            );
            return;
        }

        await _auth.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        emit(AuthenticationError(_handleFirebaseAuthException(e)));
      }
    }
  }

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (state is Unautheticated) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _auth.currentUser!.updateDisplayName(name);
      } on FirebaseAuthException catch (e) {
        emit(AuthenticationError(_handleFirebaseAuthException(e)));
      }
    }
  }

  Future<void> deleteAccount({
    required ms_entities.CredentialProvider provider,
    String? email,
    String? password,
    String? accessToken,
    String? idToken,
  }) async {
    if (state is Autheticated) {
      // TODO: Verificar se os dados informados batem com o tipo de provider informado.

      try {
        var currentUser = _auth.currentUser!;

        AuthCredential credential;

        switch (provider) {
          case ms_entities.CredentialProvider.email:
            credential = EmailAuthProvider.credential(
              email: email!,
              password: password!,
            );
            break;
          case ms_entities.CredentialProvider.facebook:
            credential = FacebookAuthProvider.credential(accessToken!);
            break;
          case ms_entities.CredentialProvider.google:
            credential = GoogleAuthProvider.credential(
              accessToken: accessToken,
              idToken: idToken,
            );
            break;
        }

        await currentUser.reauthenticateWithCredential(credential);

        await _auth.currentUser!.delete();
      } on FirebaseAuthException catch (e) {
        emit(
          AccountDeletionError(
            (state as Autheticated).user,
            _handleFirebaseAuthException(e),
          ),
        );
      }
    }
  }
}
