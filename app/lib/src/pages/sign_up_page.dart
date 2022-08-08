import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';

import '../state_managers.dart';
import '../utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final Logger _logger = KiwiContainer().resolve();
  final AuthCubit _authCubit = KiwiContainer().resolve();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criação de Conta"),
        centerTitle: true,
      ),
      body: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom / 2,
            ),
            child: ConstrainedBox(
              constraints: constraints,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Nome (opcional)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
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
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Senha",
                          border: OutlineInputBorder(),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Este campo é obrigatório";
                          }

                          if (text.compareTo(
                                  _passwordConfirmationController.text) !=
                              0) {
                            return "As senhas devem ser iguais";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordConfirmationController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Confirme sua senha",
                          border: OutlineInputBorder(),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Este campo é obrigatório";
                          }

                          if (text.compareTo(_passwordController.text) != 0) {
                            return "As senhas devem ser iguais";
                          }

                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => GoRouter.of(context).pop(),
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _logger.i(
                                  "Formulário de criação de usuário válido.",
                                );

                                _authCubit.signUpWithEmail(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                _authCubit.updateName(_nameController.text);
                              } else {
                                _logger.i("Formulário não foi aceito");
                              }
                            },
                            child: const Text("Criar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
