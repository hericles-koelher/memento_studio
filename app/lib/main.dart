import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MementoStudio());
}

class MementoStudio extends StatelessWidget {
  const MementoStudio({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _status = "Unauthenticated User";
  String _buttonText = "Login";
  String _textFromServer = "";
  bool _isLoggedIn = false;
  bool _successfullHelloFromServer = false;

  @override
  void initState() {
    super.initState();

    if (_firebaseAuth.currentUser != null) {
      helloServer();

      _updateScreen(true);
    }
  }

  void _updateScreen(bool isLoggedIn) {
    if (isLoggedIn) {
      setState(() {
        _status = "User Logged ${_firebaseAuth.currentUser!.email}";
        _buttonText = "Logout";
        _isLoggedIn = true;
      });
    } else {
      setState(() {
        _status = "User Unauthenticated";
        _buttonText = "Login";
        _isLoggedIn = false;
        _successfullHelloFromServer = false;
      });
    }
  }

  Future<void> helloServer() async {
    String token = await _firebaseAuth.currentUser!.getIdToken();

    // endereço utilizado no emulador...
    Response response = await Dio().get("http://10.0.2.2:8080/hello-world",
        options: Options(
          responseType: ResponseType.json,
          headers: {
            "Authorization": "Bearer $token",
            "Access-Control-Allow-Origin": "*"
          },
        ));

    if (response.statusCode == 200) {
      var json = response.data;

      setState(() {
        _successfullHelloFromServer = true;
        _textFromServer = json["message"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memento Studio"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status),
            ElevatedButton(
              onPressed: () async {
                if (!_isLoggedIn) {
                  try {
                    await _firebaseAuth.signInWithEmailAndPassword(
                      email: "memento_studio@outlook.com",
                      password: "PIUFES2022",
                    );

                    debugPrint("Login Bem Sucedido");

                    helloServer();

                    _updateScreen(true);
                  } on FirebaseAuthException catch (e) {
                    debugPrint("Erro de autenticação: ${e.message}");
                  }
                } else {
                  await _firebaseAuth.signOut();

                  debugPrint("Logout Bem Sucedido");

                  _updateScreen(false);
                }
              },
              child: Text(_buttonText),
            ),
            if (_successfullHelloFromServer)
              Text("Server returned: $_textFromServer")
          ],
        ),
      ),
    );
  }
}
