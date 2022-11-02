import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/bloc/prestamos/prestamos_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:my_app/helpers/build_historiales.dart';
import 'package:my_app/helpers/dialog.dart';
import 'package:my_app/helpers/navegate_fadein.dart';
import 'package:my_app/helpers/snackbar.dart';
import 'package:my_app/models/archives_model.dart';
import 'package:my_app/pages/pdf_view.dart';

class HistorialPrestamos extends StatefulWidget {
  final String nombre;
  final ArchivesModel archivesModel;

  const HistorialPrestamos(
      {Key? key, required this.nombre, required this.archivesModel})
      : super(key: key);

  @override
  State<HistorialPrestamos> createState() => _HistorialPrestamosState();
}

class _HistorialPrestamosState extends State<HistorialPrestamos> {
  late PrestamosBloc prestamosBloc;
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    prestamosBloc = BlocProvider.of<PrestamosBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  final action = await Dialogs.yesAbortDialog(
                      context,
                      'Historial de Prestamo',
                      'Imprimir reporte de ${widget.nombre}?');
                  if (action == DialogAction.yes && mounted) {
                    final pdfView =
                        await BuildHistoriales.buildHistorialPersonal(context,
                            prestamosBloc.state.prestamos, widget.nombre);
                    if (mounted) {
                      Navigator.push(context,
                          navegarFadeIn(context, PDFViewPage(data: pdfView)));
                    }
                  } else {}
                },
                icon: const Icon(Icons.add_chart_outlined)),
            const SizedBox(
              width: 10,
            ),
          ],
          title: Text(
            "  Historial de Prestamos: ${widget.nombre}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.black,
        ),
        body: BlocBuilder<PrestamosBloc, PrestamosState>(
          builder: (context, state) {
            return ListView(
              children: [
                if (state.prestamos.isNotEmpty)
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    shrinkWrap: true,
                    itemCount: state.prestamos.length,
                    itemBuilder: (ctx, i) {
                      final data = state.prestamos[i];
                      final formatter = intl.NumberFormat.decimalPattern();

                      return ListTile(
                        onLongPress: () async {
                          final action = await Dialogs.yesAbortDialog(
                              context,
                              'Eliminar Prestamo',
                              'Deseas Eliminar este Prestamo?');
                          if (action == DialogAction.yes) {
                            prestamosBloc.borrarPrestamo(data.id!);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            CustomWidgets.buildSnackbar(context,
                                "Eliminado Correctamente", Icons.check);
                          } else {}
                        },
                        onTap: () {
                          final List<Map<String, dynamic>> ardata =
                              (jsonDecode(data.data) as List)
                                  .map((e) => e as Map<String, dynamic>)
                                  .toList();
                          prestamosBloc.add(ChargeAllData(
                              data.interes,
                              data.cuotas,
                              data.monto,
                              ardata,
                              widget.archivesModel,
                              data.totalInteres!,
                              data.totalAPagar!,
                              data.fecha,
                              data.fechaMili,
                              data.interesMoratorio,
                              data.interesPunitorio,
                              data.id!));
                          loginBloc.selectedIndex(1, true);
                          Navigator.pop(context);
                        },
                        leading: const Icon(
                          Icons.monetization_on,
                          color: Colors.black,
                          size: 20,
                        ),
                        title: Text("Numero de Cuotas: ${data.cuotas} "),
                        subtitle: Text(
                            "Monto Prestado: ${formatter.format(data.monto)} Gs"),
                        trailing: Text(
                          data.fecha,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      );
                    },
                  ),
                if (state.prestamos.isEmpty) ...[
                  Lottie.asset('images/empy.json', height: size.height * 0.30),
                  const Center(
                      child: Text(
                    "No Tiene Prestamos Vigentes",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ))
                ]
              ],
            );
          },
        ));
  }
}
