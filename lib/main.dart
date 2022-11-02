import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/bloc/prestamos/prestamos_bloc.dart';
import 'package:my_app/pages/login_data.dart';
import 'package:my_app/pages/tab_screen.dart';
import 'package:my_app/routes/routes.dart';
import 'package:my_app/shared/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setMinWindowSize(const Size(1500, 800));
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<PrestamosBloc>(
          create: (context) => PrestamosBloc(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('es')
        ],
        debugShowCheckedModeBanner: false,
        routes: appRoutes,
        home: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return state.isLoged ? const TabScreen() : const LoginData();
          },
        ));
  }
}
