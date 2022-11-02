import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/helpers/navegate_fadein.dart';
import 'package:my_app/helpers/snackbar.dart';
import 'package:my_app/pages/tab_screen.dart';
import 'package:my_app/shared/preferencias_usuario.dart';
import 'package:my_app/widgets/custom_button.dart';

class InputLogin extends StatefulWidget {
  const InputLogin({Key? key}) : super(key: key);

  @override
  State<InputLogin> createState() => _InputLoginState();
}

class _InputLoginState extends State<InputLogin> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final prefs = PreferenciasUsuario();

  String nombre = "";
  String password = "";
  bool _registrar = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
            margin: const EdgeInsets.only(top: 100),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 370,
                ),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().length < 2) {
                              return 'Usuario deve Alemnos 2 Caracteres';
                            }
                            return null;
                          },
                          onSaved: (value) => nombre = value!,
                          key: const ValueKey('email'),
                          style: const TextStyle(color: Colors.white),
                          decoration: buildInputDecoration(
                              hint: 'Ingrese su Usuario',
                              label: 'Usuario',
                              icon: Icons.account_circle),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().length < 3) {
                              return 'Password deve Contener almenos 3 Caracteres';
                            }
                            return null;
                          },
                          onSaved: (value) => password = value!,
                          key: const ValueKey('passwod'),
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: buildInputDecoration(
                              hint: '*****',
                              label: 'Contraseña',
                              icon: Icons.lock_outline),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        (_isLoading == false)
                            ? CustomButton(
                                text: _registrar ? "Registrar" : 'Hacer Login',
                                onPressed: () {
                                  _submit();
                                },
                                color: Colors.amber)
                            : const CircularProgressIndicator(),
                        const SizedBox(
                          height: 30,
                        ),
                        if (prefs.nombreUsuario.isEmpty)
                          TextButton(
                              onPressed: () {
                                if (_registrar) {
                                  _registrar = false;
                                } else {
                                  _registrar = true;
                                }
                                setState(() {});
                              },
                              child: Text(
                                _registrar ? "Loguear" : "Registrar",
                                style: const TextStyle(color: Colors.white),
                              )),
                        TextButton(
                            onPressed: () {
                              CustomWidgets.buildsenhaEmergencia(context);
                            },
                            child: const Text("Emergencia"))
                      ],
                    )),
              ),
            ));
      },
    );
  }

  Future<void> _submit() async {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_registrar && prefs.nombreUsuario.isEmpty) {
        prefs.nombreUsuario = nombre;
        prefs.password = password;
        loginBloc.add(DetectLogin(true));
        CustomWidgets.buildSnackbar(
            context,
            "Bienvenido ${prefs.nombreUsuario}",
            Icons.sentiment_very_satisfied_outlined);
      } else if (_registrar && prefs.nombreUsuario.isNotEmpty) {
        CustomWidgets.buildSnackbar(
            context, "Usuario Ya Registrado", Icons.info);
      } else if (_registrar == false && prefs.password == password) {
        Navigator.push(context, navegarFadeIn(context, const TabScreen()));
        CustomWidgets.buildSnackbar(
            context,
            "Bienvenido ${prefs.nombreUsuario}",
            Icons.sentiment_very_satisfied_outlined);
      } else {
        CustomWidgets.buildSnackbar(
            context, "Contraseña o Usuario Incorrecto", Icons.info);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      return;
    }
  }
}

InputDecoration buildInputDecoration({
  required String hint,
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hint,
    labelText: label,
    hintStyle: const TextStyle(color: Colors.grey),
    labelStyle: const TextStyle(color: Colors.grey),
    prefixIcon: Icon(
      icon,
      color: Colors.grey,
    ),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3))),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3))),
  );
}
