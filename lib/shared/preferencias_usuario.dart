


 import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
   
    static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

 
   String get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? '';
  }

  set nombreUsuario(String value) {
    _prefs.setString('nombreUsuario', value);
  }

     String get password {
    return _prefs.getString('password') ?? '';
  }

  set password(String value) {
    _prefs.setString('password', value);
  }

     String get emergencia {
    return _prefs.getString('emergencia') ?? '242524';
  }

  set emergencia(String value) {
    _prefs.setString('emergencia', value);
  }


 }