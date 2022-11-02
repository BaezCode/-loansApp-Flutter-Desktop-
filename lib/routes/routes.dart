import 'package:flutter/material.dart';
import 'package:my_app/pages/login_data.dart';
import 'package:my_app/pages/nuevo_cliente.dart';
import 'package:my_app/pages/tab_screen.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'login': (_) => const LoginData(),
  'home': (_) => const TabScreen(),
  'nuevoCli': (_) => const NuevoCliente(),
};
