import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memento_studio/src/blocs.dart';
import 'package:mocktail/mocktail.dart';

// ------------------------------- MOCKS -------------------------------

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

// ------------------------------- TESTS -------------------------------

void main() {
  // ------------------------------- VAR SETUP -------------------------------
  String email = "digimon123@hotmail.com";
  String password = "Senha1234";
  String uid = "banana";
  String displayName = "Barões da Pisadinha";
  String token = "tokenBananinha";

  // ------------------------------- TEST SETUP -------------------------------

  test("Criação de usuário com email deve funcionar", () async {
    var auth = MockFirebaseAuth();
    var user = MockUser();

    when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((invocation) async {
      return MockUserCredential();
    });
    when(() => auth.userChanges()).thenAnswer((invocation) async* {
      yield null;
      yield user;
    });

    when(() => user.uid).thenAnswer((invocation) => uid);
    when(() => user.displayName).thenAnswer((invocation) => displayName);
    when(() => user.getIdToken()).thenAnswer((invocation) async => token);
    when(() => user.providerData).thenAnswer(
      (invocation) => [
        UserInfo({
          "providerId": EmailAuthProvider.PROVIDER_ID,
        })
      ],
    );

    var authCubit = AuthCubit(auth);

    await authCubit.signUpWithEmail(
      email: email,
      password: password,
    );

    await Future.delayed(const Duration(seconds: 2));

    expect(authCubit.state, isA<Autheticated>());
  });

  test("Criação de usuário com email deve falhar", () async {
    var auth = MockFirebaseAuth();

    when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(code: "invalid-email"));
    when(() => auth.userChanges()).thenAnswer((invocation) async* {
      yield null;
    });

    var authCubit = AuthCubit(auth);

    // Pra dar tempo da stream ser utilizada e o estado ser definido como "Unauthenticated"
    await Future.delayed(const Duration(seconds: 1));

    await authCubit.signUpWithEmail(
      email: email,
      password: password,
    );

    await Future.delayed(const Duration(seconds: 1));

    expect(authCubit.state, isA<AuthenticationError>());
  });
}
