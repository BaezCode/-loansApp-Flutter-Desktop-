// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/bloc/prestamos/prestamos_bloc.dart';
import 'package:my_app/helpers/build_modificar_cuota.dart';
import 'package:my_app/helpers/build_ticket.dart';
import 'package:my_app/helpers/dialog.dart';
import 'package:my_app/helpers/navegate_fadein.dart';
import 'package:my_app/models/archives_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:my_app/pages/pdf_view.dart';

class PrestamoDataSources extends DataTableSource {
  final BuildContext context;
  final ArchivesModel archivesModel;
  final List<Map<String, dynamic>> data;

  PrestamoDataSources(this.context, this.data, this.archivesModel);

  @override
  DataRow? getRow(int index) {
    final prestamosBloc = BlocProvider.of<PrestamosBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final formatter = intl.NumberFormat.decimalPattern();

    final result = data[index]["quitado"] == "Pagado" ? false : true;
    int dia = 0;
    final dayNow = DateTime.now();
    DateTime tempDate = DateFormat("dd-MM-yyyy").parse(data[index]["fecha"]);
    if (dayNow.difference(tempDate).inDays.isNegative == false &&
        data[index]['quitado'] == "Pendiente") {
      dia = dayNow.difference(tempDate).inDays;
      if (dia > 0 && loginBloc.state.isUpdate) {
        data[index].update("atraso", (value) => dia);
        if (dia > 3) {
          final interes = prestamosBloc.state.interesMoratorio / 100;
          final generate = data[index]['interes'] * interes;
          final totalDia = dia - 3;
          data[index].update("I.Moratorio", (value) => generate * totalDia);
        }
        prestamosBloc.update(archivesModel, data);
      }
    }

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(data[index]["Nro"]!)),
      DataCell(MaterialButton(
        onPressed: () async {
          final action = await Dialogs.yesAbortDialog(
              context,
              'Cuotas',
              result == true
                  ? 'Desea Marcar esta Cuota Como Pagada y imprimir el recibo?'
                  : 'Desea Volver a imprimir el recibo?');
          if (action == DialogAction.yes) {
            if (result) {
              data[index].update("quitado", (value) => "Pagado");
              data[index].update(
                  "Fecha de Pago", (value) => data[index]['fecha'].toString());

              prestamosBloc.update(archivesModel, data);
              final pdfView =
                  await BuildTicket.buildTicket(data[index], archivesModel);
              Navigator.push(
                  context, navegarFadeIn(context, PDFViewPage(data: pdfView)));
            } else {
              final pdfView =
                  await BuildTicket.buildTicket(data[index], archivesModel);
              Navigator.push(
                  context, navegarFadeIn(context, PDFViewPage(data: pdfView)));
            }
          } else {}
        },
        child: Text(data[index]["quitado"]!,
            style: TextStyle(
                color: result ? Colors.red : Colors.blue,
                fontWeight: FontWeight.bold)),
      )),
      DataCell(TextButton(
          onPressed: () async {
            DateTime tempDate =
                DateFormat("dd-MM-yyyy").parse(data[index]["fecha"]);

            final newDate = await showDatePicker(
              locale: const Locale("es"),
              context: context,
              initialDate: tempDate,
              firstDate: DateTime(2010),
              lastDate: DateTime(2035),
            );
            if (newDate == null) return;
            final fechaFinal = Jiffy(newDate).format("dd-MM-yyyy");
            data[index].update("Fecha de Pago", (value) => fechaFinal);
            prestamosBloc.update(archivesModel, data);
          },
          child: Text("${data[index]["Fecha de Pago"]!}"))),
      DataCell(Text("${data[index]["fecha"]!}")),
      DataCell(TextButton(
          onPressed: () {}, child: Text("${data[index]["atraso"]!} Dias"))),
      DataCell(
          Text("${formatter.format(data[index]['cuota']!).split(".")[0]} Gs")),
      DataCell(Text("${formatter.format(data[index]['interes']!)} Gs")),
      DataCell(
          Text("${formatter.format(data[index]['abono']!).split(".")[0]} Gs")),
      DataCell(
          Text("${formatter.format(data[index]['Saldo']!).split(".")[0]} Gs")),
      DataCell(Text("${formatter.format(data[index]["I.Moratorio"])} Gs")),
      DataCell(Text("${formatter.format(data[index]["I.punitorio"])} Gs")),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
