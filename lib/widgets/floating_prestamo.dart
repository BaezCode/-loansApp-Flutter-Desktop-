import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/bloc/prestamos/prestamos_bloc.dart';
import 'package:my_app/helpers/dialog.dart';
import 'package:my_app/helpers/snackbar.dart';

class FloatingPrestamo extends StatefulWidget {
  const FloatingPrestamo({Key? key}) : super(key: key);

  @override
  State<FloatingPrestamo> createState() => _FloatingPrestamoState();
}

class _FloatingPrestamoState extends State<FloatingPrestamo> {
  @override
  Widget build(BuildContext context) {
    final prestamosBloc = BlocProvider.of<PrestamosBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: () async {
        final action = await Dialogs.yesAbortDialog(context, 'Generar Prestamo',
            'Deseas Guardar los Cambios y Generar el Historial?');
        if (action == DialogAction.yes) {
          final usuario = prestamosBloc.state.archivesModel!;
          final results = loginBloc.state.isUpdate == false
              ? await prestamosBloc.saveData(prestamosBloc.state, usuario)
              : await prestamosBloc.update(usuario, prestamosBloc.state.data);

          if (results && mounted) {
            CustomWidgets.buildSnackbar(
                context, "Guardado Correctamente", Icons.check);
            loginBloc.selectedIndex(0, false);
          } else {
            CustomWidgets.buildSnackbar(context, "Error Intente de Nuevo",
                Icons.sentiment_dissatisfied);
          }
        } else {}
      },
      child: const Icon(Icons.save),
    );
  }
}
