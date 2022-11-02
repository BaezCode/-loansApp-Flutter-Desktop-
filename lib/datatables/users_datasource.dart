import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/bloc/prestamos/prestamos_bloc.dart';
import 'package:my_app/helpers/dialog.dart';
import 'package:my_app/helpers/navegate_fadein.dart';
import 'package:my_app/helpers/snackbar.dart';
import 'package:my_app/models/archives_model.dart';
import 'package:my_app/pages/historial_prestamos.dart';
import 'package:my_app/screens/perfil_page.dart';

class UsersDataSource extends DataTableSource {
  final BuildContext context;
  final List<ArchivesModel> archives;

  UsersDataSource(this.context, this.archives);

  @override
  DataRow? getRow(int index) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final prestamosBloc = BlocProvider.of<PrestamosBloc>(context);

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(archives[index].idCliente!)),
      DataCell(Text(archives[index].nombre)),
      DataCell(Text(archives[index].telefono)),
      DataCell(Text(archives[index].cedula.toString())),
      DataCell(
        IconButton(
            onPressed: () async {
              await prestamosBloc
                  .cargarPrestamosPorID(archives[index].idCliente!);

              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  // ignore: use_build_context_synchronously
                  navegarFadeIn(
                      context,
                      HistorialPrestamos(
                          nombre: archives[index].nombre,
                          archivesModel: archives[index])));
            },
            icon: const Icon(
              Icons.history_edu_rounded,
              size: 22,
            )),
      ),
      DataCell(IconButton(
          icon: const Icon(
            Icons.remove_red_eye_sharp,
            size: 22,
          ),
          onPressed: () {
            Navigator.push(
                context,
                navegarFadeIn(
                    context, PerfilPage(archivesModel: archives[index])));
          })),
      DataCell(IconButton(
          onPressed: () {
            final loginBloc = BlocProvider.of<LoginBloc>(context);
            final prestamosBloc = BlocProvider.of<PrestamosBloc>(context);
            prestamosBloc.add(ClearAll());
            prestamosBloc.add(SetUser(archives[index]));
            loginBloc.selectedIndex(1, false);
          },
          icon: const Icon(
            Icons.add,
            color: Colors.black,
            size: 22,
          ))),
      DataCell(IconButton(
          onPressed: () async {
            final action = await Dialogs.yesAbortDialog(
                context,
                'Eliminar Usuario',
                'Deseas Eliminar a ${archives[index].nombre} y todo su historial de Prestamos?');
            if (action == DialogAction.yes) {
              loginBloc.borrarUsuarios(archives[index].id!);
              // ignore: use_build_context_synchronously
              CustomWidgets.buildSnackbar(
                  context, "Usuario Eliminado Correctamente", Icons.check);
            } else {}
          },
          icon: const Icon(
            CupertinoIcons.delete,
            color: Colors.black,
            size: 22,
          )))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => archives.length;

  @override
  int get selectedRowCount => 0;
}
