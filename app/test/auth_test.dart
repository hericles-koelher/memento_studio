import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memento_studio/src/state_managers.dart';
import 'package:memento_studio/src/entities.dart' as ms_entities;
import 'package:memento_studio/src/exceptions.dart';
import 'package:mocktail/mocktail.dart';

// ------------------------------- MOCKS -------------------------------

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockAuthCredential extends Mock implements AuthCredential {}

// ------------------------------- TESTS -------------------------------

void main() {
  // ------------------------------- VAR SETUP -------------------------------
  String email = "digimon123@hotmail.com";
  String password = "Senha1234";
  String uid = "banana";
  String displayName = "Barões da Pisadinha";
  String token = "tokenBananinha";

  // ------------------------------- TEST SETUP -------------------------------

  setUpAll(() {
    registerFallbackValue(MockAuthCredential());
  });

  test("Criação de usuário com email deve funcionar", () async {
    var auth = MockFirebaseAuth();
    var user = MockUser();

    when(() => auth.createUserWithEmailAndPassword(
          email: any(named: "email"),
          password: any(named: "password"),
        )).thenAnswer((_) async {
      return MockUserCredential();
    });
    when(() => auth.userChanges()).thenAnswer((_) async* {
      yield null;
      yield user;
    });

    when(() => user.uid).thenAnswer((_) => uid);
    when(() => user.displayName).thenAnswer((_) => displayName);
    when(() => user.getIdToken()).thenAnswer((_) async => token);
    when(() => user.providerData).thenAnswer(
      (_) => [
        UserInfo({
          "providerId": EmailAuthProvider.PROVIDER_ID,
        })
      ],
    );

    var authCubit = AuthCubit(auth);

    authCubit.signUpWithEmail(
      email: email,
      password: password,
    );

    await Future.delayed(const Duration(seconds: 2));

    expect(authCubit.state, isA<Authenticated>());
  });

  test("Criação de usuário com email deve falhar", () async {
    var auth = MockFirebaseAuth();

    when(() => auth.createUserWithEmailAndPassword(
          email: any(named: "email"),
          password: any(named: "password"),
        )).thenThrow(FirebaseAuthException(code: "invalid-email"));
    when(() => auth.userChanges()).thenAnswer((_) async* {
      yield null;
    });

    var authCubit = AuthCubit(auth);

    // Pra dar tempo da stream ser utilizada e o estado ser definido como "Unauthenticated"
    await Future.delayed(const Duration(seconds: 1));

    authCubit.signUpWithEmail(
      email: email,
      password: password,
    );

    await Future.delayed(const Duration(seconds: 1));

    expect(authCubit.state, isA<AuthenticationError>());
  });

  test("Autenticação de usuário deve funcionar", () async {
    var auth = MockFirebaseAuth();
    var user = MockUser();

    when(() => auth.signInWithCredential(any())).thenAnswer((_) async {
      return MockUserCredential();
    });
    when(() => auth.userChanges()).thenAnswer((_) async* {
      yield null;
      yield user;
    });

    when(() => user.uid).thenAnswer((_) => uid);
    when(() => user.displayName).thenAnswer((_) => displayName);
    when(() => user.getIdToken()).thenAnswer((_) async => token);
    when(() => user.providerData).thenAnswer(
      (_) => [
        UserInfo({
          "providerId": FacebookAuthProvider.PROVIDER_ID,
        })
      ],
    );

    var authCubit = AuthCubit(auth);

    authCubit.signInWithCredential(
      ms_entities.Credential.fromFacebook("accessToken"),
    );

    await Future.delayed(const Duration(seconds: 2));

    expect(authCubit.state, isA<Authenticated>());
  });

  test("Autenticação de usuário deve falhar", () async {
    var auth = MockFirebaseAuth();

    when(() => auth.signInWithCredential(any())).thenThrow(
      FirebaseAuthException(
        code: "account-exists-with-different-credential",
      ),
    );
    when(() => auth.userChanges()).thenAnswer((_) async* {
      yield null;
    });

    var authCubit = AuthCubit(auth);

    // Pra dar tempo da stream ser utilizada e o estado ser definido como "Unauthenticated"
    await Future.delayed(const Duration(seconds: 1));

    authCubit.signInWithCredential(
      ms_entities.Credential.fromFacebook("accessToken"),
    );

    await Future.delayed(const Duration(seconds: 1));

    expect(authCubit.state, isA<AuthenticationError>());
    expect(
      (authCubit.state as AuthenticationError).exception.code,
      MSAuthExceptionCode.accountExistsWithDifferentCredential,
    );
  });
}
