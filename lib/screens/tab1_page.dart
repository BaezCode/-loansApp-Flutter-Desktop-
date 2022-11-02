import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/datatables/users_datasource.dart';
import 'package:my_app/widgets/menu_pop_home.dart';

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    loginBloc.cargarscans();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                if (state.archives.isNotEmpty) ...[
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Contactos",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MenuPopHome()
                    ],
                  ),
                  PaginatedDataTable(
                      horizontalMargin: 10.0,
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('telefono')),
                        DataColumn(label: Text('C.I')),
                        DataColumn(label: Text('Historial de Prestamos')),
                        DataColumn(label: Text('Ver Perfil')),
                        DataColumn(label: Text('Nuevo Prestamo')),
                        DataColumn(label: Text('Eliminar Cliente')),
                      ],
                      source: UsersDataSource(context, state.archives)),
                ],
                if (state.archives.isEmpty) ...[
                  Lottie.asset('images/empy.json', height: size.height * 0.30),
                  const Center(
                      child: Text(
                    "No tienes Clientes Registrados",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ))
                ]
              ],
            ));
      },
    );
  }
}
