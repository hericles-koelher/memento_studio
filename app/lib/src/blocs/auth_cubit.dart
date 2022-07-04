import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../exceptions.dart';
import '../entities.dart' as ms_entities;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  StreamSubscription? _userStreamSubscription;

  AuthCubit(FirebaseAuth auth)
      : _auth = auth,
        super(Unknown()) {
    _listenToUserStream();
  }

  ms_entities.CredentialProvider? _getUserProvider(User user) {
    String? providerId = user.providerData.first.providerId;

    if (EmailAuthProvider.PROVIDER_ID.compareTo(providerId) == 0) {
      return ms_entities.CredentialProvider.email;
    } else if (FacebookAuthProvider.PROVIDER_ID.compareTo(providerId) == 0) {
      return ms_entities.CredentialProvider.facebook;
    } else if (GoogleAuthProvider.PROVIDER_ID.compareTo(providerId) == 0) {
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
              provider: _getUserProvider(user)!,
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

  Future<void> deleteAccount(ms_entities.Credential credential) async {
    if (state is Autheticated) {
      try {
        emit(AccountDeletionLoading((state as Autheticated).user));

        var currentUser = _auth.currentUser!;

        AuthCredential fbCredential;

        if (credential is ms_entities.EmailCredential) {
          fbCredential = EmailAuthProvider.credential(
            email: credential.email,
            password: credential.password,
          );
        } else if (credential is ms_entities.FacebookCredential) {
          fbCredential =
              FacebookAuthProvider.credential(credential.accessToken);
        } else if (credential is ms_entities.GoogleCredential) {
          fbCredential = GoogleAuthProvider.credential(
            accessToken: credential.accessToken,
            idToken: credential.idToken,
          );
        } else {
          emit(AuthenticationError(
            MSAuthException(
              code: MSAuthExceptionCode.invalidCredentialType,
              message:
                  "O tipo de credencial informado não é utilizado no momento",
            ),
          ));
          return;
        }

        await currentUser.reauthenticateWithCredential(fbCredential);

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
          (state as Autheticated).user.copyWith(
                token: await _auth.currentUser!.getIdToken(),
              ),
        ),
      );
    }
  }

  Future<void> signInWithCredential(ms_entities.Credential credential) async {
    try {
      emit(Loading());

      AuthCredential fbCredential;

      if (credential is ms_entities.EmailCredential) {
        fbCredential = EmailAuthProvider.credential(
          email: credential.email,
          password: credential.password,
        );
      } else if (credential is ms_entities.FacebookCredential) {
        fbCredential = FacebookAuthProvider.credential(credential.accessToken);
      } else if (credential is ms_entities.GoogleCredential) {
        fbCredential = GoogleAuthProvider.credential(
          accessToken: credential.accessToken,
          idToken: credential.idToken,
        );
      } else {
        emit(AuthenticationError(
          MSAuthException(
            code: MSAuthExceptionCode.invalidCredentialType,
            message:
                "O tipo de credencial informado não é utilizado no momento",
          ),
        ));
        return;
      }

      await _auth.signInWithCredential(fbCredential);
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationError(_handleFirebaseAuthException(e)));
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    if (state is Unautheticated) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        emit(AuthenticationError(_handleFirebaseAuthException(e)));
      }
    }
  }

  Future<void> updateName(String? name) async {
    if (state is Autheticated) {
      await _auth.currentUser!.updateDisplayName(name);
    }
  }

  // TODO: codificar updateEmail e updatePassword e configurar o firebase para tal...
}
