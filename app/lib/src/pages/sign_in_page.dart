import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/blocs.dart';
import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/utils.dart';

import '../widgets.dart';

// TODO: Salvar o endereço de email em algum local caso usuário selecione essa opção...
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final Logger _logger = KiwiContainer().resolve();
  final AuthCubit _authCubit = KiwiContainer().resolve();
  final GoogleSignIn _googleSignIn = KiwiContainer().resolve();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePasswordText = true;
  bool _remember = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const MSDrawer(),
      appBar: AppBar(centerTitle: true, title: const Text("Autenticação")),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom / 2,
          ),
          child: ConstrainedBox(
            constraints: constraints,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: "E-mail",
                              border: OutlineInputBorder(),
                            ),
                            validator: (email) {
                              if (email == null || !Validator.isEmail(email)) {
                                return "E-mail inválido";
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePasswordText,
                            decoration: InputDecoration(
                              labelText: "Senha",
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePasswordText =
                                        !_obscurePasswordText;
                                  });
                                },
                                icon: FaIcon(
                                  _obscurePasswordText
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: _remember,
                                    onChanged: (state) {
                                      setState(() {
                                        _remember = state ?? false;
                                      });
                                    },
                                  ),
                                  const Text("Lembrar-me")
                                ],
                              ),
                            ),
                            Flexible(
                              child: TextButton(
                                child: const Text("Esqueci minha senha"),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _logger.i("Formulário de login válido.");

                              _authCubit.signInWithCredential(
                                Credential.fromEmail(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            } else {
                              _logger.i("Formulário não foi aceito");
                            }
                          },
                          child: const Text("Entrar"),
                        ),
                      ],
                    ),
                  ),
                ),
                const Text("ou"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: const SizedBox.square(
                        dimension: 48,
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.facebook,
                            size: iconButtonSize,
                          ),
                        ),
                      ),
                      onTap: () async {
                        var loginResult = await FacebookAuth.i.login();

                        _logger.d(loginResult.status);

                        if (loginResult.status == LoginStatus.success) {
                          _logger.i(
                            "Autenticação com Facebook foi permitida",
                          );

                          var credential = Credential.fromFacebook(
                            loginResult.accessToken!.token,
                          );

                          _authCubit.signInWithCredential(credential);
                        }
                      },
                    ),
                    InkWell(
                      child: const SizedBox.square(
                        dimension: 48,
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.google,
                            size: iconButtonSize,
                          ),
                        ),
                      ),
                      onTap: () async {
                        var googleAccount = await _googleSignIn.signIn();

                        if (googleAccount != null) {
                          googleAccount.authentication.then((authData) {
                            _logger.i(
                              "Autenticação com Google foi permitida",
                            );

                            _authCubit.signInWithCredential(
                              Credential.fromGoogle(
                                accessToken: authData.accessToken,
                                idToken: authData.idToken,
                              ),
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Não tem uma conta?"),
                      TextButton(
                        onPressed: () =>
                            GoRouter.of(context).goNamed("sign_up"),
                        child: const Text("Crie uma"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
