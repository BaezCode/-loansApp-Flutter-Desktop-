

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/shared/preferencias_usuario.dart';
import 'package:my_app/widgets/input_login.dart';
import 'package:my_app/widgets/login_image.dart';


class LoginData extends StatefulWidget {
  const LoginData({Key? key}) : super(key: key);

  @override
  State<LoginData> createState() => _LoginDataState();
}

class _LoginDataState extends State<LoginData> {


  
  late LoginBloc loginBloc;
  final prefs = PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
     loginBloc = BlocProvider.of<LoginBloc>(context);
     _getData();
  }

   void _getData(){
    //s loginBloc.add(DetectLogin(prefs.password));
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scrollbar(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
         _crearBody(context)
        ],
      ),
    ));
     
    
  }

  Widget _crearBody(BuildContext context) {

      final size = MediaQuery.of(context).size;
      return Container(
      color: Colors.black,
      width: size.width,
      height: size.height,
      child: Row(
        children: [
          const LoginImage(),
          Container(
            width: 800,
            height: double.infinity,
            color: Colors.black,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                 _crearTitulo(context),
                const SizedBox(
                  height: 50,
                ),
                const Expanded(child: InputLogin())
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _crearTitulo(BuildContext context){

    final size = MediaQuery.of(context).size;

     return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Image(
            height:  size.height * 0.25,
            image: const AssetImage("images/ofi.jpeg")),
     
          const SizedBox(
            height: 30,
          ),
          const FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'Panel Bienvenido...',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          )
        ],
      ),
    );
  }
}


