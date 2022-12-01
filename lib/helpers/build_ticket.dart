import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:my_app/models/archives_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart' as intl;

class BuildTicket {
  BuildTicket._();

  static Future<Uint8List> buildTicket(data, ArchivesModel usuario) {
    final pdf = pw.Document();
    final formatter = intl.NumberFormat.decimalPattern();

    pdf.addPage(pw.MultiPage(
      pageFormat: const PdfPageFormat(
          8 * PdfPageFormat.cm, 17 * PdfPageFormat.cm,
          marginAll: 0.5 * PdfPageFormat.cm),
      build: (context) => [
        pw.Center(
          child: pw.Text("Pedro Juan Caballero - Paraguay",
              style: pw.TextStyle(fontSize: 11)),
        ),
        pw.SizedBox(height: 5),
        pw.Center(
          child: pw.Text("RECIBO DE DINERO", style: pw.TextStyle(fontSize: 11)),
        ),
        pw.SizedBox(height: 20),
        pw.Text("C.I. / RUC N: ${usuario.cedula}",
            style: const pw.TextStyle(fontSize: 11)),
        pw.Text("Recibimos de:", style: pw.TextStyle(fontSize: 11)),
        pw.Text(usuario.nombre, style: pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 10),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text("Descripcion", style: pw.TextStyle(fontSize: 11)),
          pw.Text("Monto", style: pw.TextStyle(fontSize: 11)),
        ]),
        pw.SizedBox(height: 10),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text("Cuota: ${data["Nro"]}", style: pw.TextStyle(fontSize: 11)),
          pw.Text(formatter.format(data["abono"]).split(".")[0],
              style: pw.TextStyle(fontSize: 11)),
        ]),
        pw.SizedBox(height: 10),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text("Intereses:", style: pw.TextStyle(fontSize: 11)),
          pw.Text(formatter.format(data["interes"]).split(".")[0],
              style: pw.TextStyle(fontSize: 11)),
        ]),
        pw.SizedBox(height: 35),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text("Total:", style: pw.TextStyle(fontSize: 11)),
          pw.Text(formatter.format(data['cuota']!).split(".")[0],
              style: pw.TextStyle(fontSize: 11)),
        ]),
        pw.SizedBox(height: 10),
        pw.Text("Lugar: CASA CENTRAL", style: pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 5),
        pw.Text("FECHA: ${data["fecha"]!}", style: pw.TextStyle(fontSize: 11)),
      ],
    ));

    return pdf.save();
  }
}
