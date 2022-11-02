import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/helpers/dialog.dart';
import 'package:my_app/helpers/snackbar.dart';
import 'package:my_app/screens/tab1_page.dart';
import 'package:my_app/screens/tab2_page.dart';
import 'package:my_app/shared/preferencias_usuario.dart';
import 'package:my_app/widgets/Floating_Tab1.dart';
import 'package:my_app/widgets/boton_nav.dart';
import 'package:my_app/widgets/floating_prestamo.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final prefs = PreferenciasUsuario();

  final List<Widget> _screens = [const Tab1(), const Tab2()];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Scaffold(
            bottomNavigationBar: state.indexHome == 1 ? const BotonNav() : null,
            appBar: AppBar(
                actions: [
                  TextButton(
                      onPressed: () {
                        CustomWidgets.buildUsuario(context);
                      },
                      child: const Text(
                        "Cambiar Nombre de Usuario",
                        style: TextStyle(color: Colors.white),
                      )),
                  TextButton(
                      onPressed: () {
                        CustomWidgets.buildUsuario(context);
                      },
                      child: const Text(
                        "Cambiar Nombre de Usuario",
                        style: TextStyle(color: Colors.white),
                      )),
                  TextButton(
                      onPressed: () {
                        CustomWidgets.buildSenha(context);
                      },
                      child: const Text(
                        "Cambiar Contraseña",
                        style: TextStyle(color: Colors.white),
                      )),
                  TextButton(
                      onPressed: () {
                        loginBloc.selectedIndex(0, false);
                      },
                      child: const Text(
                        "Inicio",
                        style: TextStyle(color: Colors.white),
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                      onPressed: () async {
                        final action = await Dialogs.yesAbortDialog(context,
                            'Cerrar Sesión', 'Deseas salir de esta cuenta?');
                        if (action == DialogAction.yes && mounted) {
                          loginBloc.add(DetectLogin(false));
                          Navigator.pushReplacementNamed(context, "login");
                        } else {}
                      },
                      child: const Text(
                        "Salir",
                        style: TextStyle(color: Colors.white),
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                ],
                toolbarHeight: size.height * 0.10,
                backgroundColor: Colors.black,
                leading: const Icon(
                  Icons.account_circle,
                  size: 40,
                ),
                title: Text(
                  prefs.nombreUsuario,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
            floatingActionButton:
                _createFloating(state.indexHome, state.isUpdate),
            body: _screens[state.indexHome]);
      },
    );
  }

  Widget _createFloating(int index, bool update) {
    switch (index) {
      case 0:
        return const FloatingTab1();
      case 1:
        return const FloatingPrestamo();
      default:
        return const FloatingTab1();
    }
  }
}
