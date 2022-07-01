import 'dart:async';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../exceptions.dart';
import '../../entities.dart' as ms_entities;

part 'auth_state.dart';

enum CredentialProvider { facebook, google }

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  StreamSubscription? _userStreamSubscription;

  AuthCubit()
      : _auth = FirebaseAuth.instance,
        super(Unknown()) {
    _listenToUserStream();
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

  Future<void> logout() async {
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
    required CredentialProvider provider,
    required String accessToken,
    String? idToken,
  }) async {
    if (state is Unautheticated) {
      try {
        emit(Loading());

        AuthCredential credential;

        switch (provider) {
          case CredentialProvider.facebook:
            credential = FacebookAuthProvider.credential(accessToken);
            break;
          case CredentialProvider.google:
            credential = GoogleAuthProvider.credential(
              accessToken: accessToken,
              idToken: idToken,
            );
            break;
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
}
