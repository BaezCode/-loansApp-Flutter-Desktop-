import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/archives_model.dart';
import 'package:my_app/models/prestamos_model.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart' as intl;

class BuildHistoriales {
  BuildHistoriales._();
  static Future<Uint8List> buildHistorialPrestamo(
    BuildContext context,
    List<PrestamosModel> prestamosModel,
    DateTime primero,
    DateTime segundo,
  ) {
    final pdf = pw.Document();
    final f = DateFormat('dd-MM-yyyy');
    final formatter = intl.NumberFormat.decimalPattern();
    double totalesMonto = 0;
    double intTotal = 0;
    double totalCapital = 0;
    double totalMoratorio = 0;
    double totalPunitorio = 0;
    final List<String> headersData = [
      "Nro",
      "Cliente",
      "Vence",
      "Atraso",
      "Cuotas",
      "Interes",
      "Capital",
      "I.M",
      "I.P",
    ];
    final List<String> totalesFinales = [
      "Total Bruto",
      "Total Interes",
      "Total Capital",
      "Total Moratorio",
      "Total Punitorio",
    ];

    pdf.addPage(pw.MultiPage(
        orientation: pw.PageOrientation.portrait,
        footer: (context) {
          return pw.Table.fromTextArray(
              cellAlignment: pw.Alignment.center,
              headers: List<String>.generate(
                  totalesFinales.length, (index) => totalesFinales[index]),
              data: List<List<String>>.generate(1, (index) {
                return [
                  formatter.format(totalesMonto).split(".")[0],
                  formatter.format(intTotal).split(".")[0],
                  formatter.format(totalCapital).split(".")[0],
                  formatter.format(totalMoratorio).split(".")[0],
                  formatter.format(totalPunitorio).split(".")[0],
                ];
              }));
        },
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
              pw.Text("Historial de Prestamos Pagados",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 20)),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Text(f.format(primero),
                    style: const pw.TextStyle(fontSize: 17)),
                pw.SizedBox(width: 10),
                pw.Text("--"),
                pw.SizedBox(width: 10),
                pw.Text(f.format(segundo),
                    style: const pw.TextStyle(fontSize: 17)),
              ]),
              pw.SizedBox(height: 5),
              pw.Divider(),
              pw.ListView.builder(
                itemCount: prestamosModel.length,
                itemBuilder: (ctx, i) {
                  final datos = json.decode(prestamosModel[i].data);

                  return pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 5),
                      child: pw.ListView(children: [
                        pw.SizedBox(height: 10),
                        pw.Align(
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Table.fromTextArray(
                                columnWidths: {
                                  0: const pw.FractionColumnWidth(0.070),
                                  1: const pw.FractionColumnWidth(0.070),
                                  2: const pw.FractionColumnWidth(0.070),
                                  3: const pw.FractionColumnWidth(0.075),
                                  4: const pw.FractionColumnWidth(0.075),
                                  5: const pw.FractionColumnWidth(0.075),
                                  6: const pw.FractionColumnWidth(0.075),
                                  7: const pw.FractionColumnWidth(0.075),
                                  8: const pw.FractionColumnWidth(0.075)
                                },
                                cellAlignment: pw.Alignment.center,
                                headers: List<String>.generate(
                                    headersData.length, (i) => headersData[i]),
                                data: List<List<String>>.generate(datos.length,
                                    (index) {
                                  if (datos[index]["quitado"] == "Pagado") {
                                    if (totalesMonto == 0) {
                                      totalesMonto = datos[index]["cuota"];
                                      intTotal = datos[index]["interes"];
                                      totalCapital = datos[index]["abono"];
                                      totalMoratorio =
                                          datos[index]["I.Moratorio"];
                                      totalPunitorio =
                                          datos[index]["I.punitorio"];
                                    } else {
                                      totalesMonto =
                                          totalesMonto + datos[index]["cuota"];
                                      intTotal =
                                          intTotal + datos[index]["interes"];
                                      totalCapital =
                                          totalCapital + datos[index]["abono"];
                                      totalMoratorio = totalMoratorio +
                                          datos[index]["I.Moratorio"];
                                      totalPunitorio = totalPunitorio +
                                          datos[index]["I.punitorio"];
                                    }
                                    return [
                                      datos[index]["Nro"],
                                      prestamosModel[i].nombre,
                                      datos[index]["fecha"],
                                      datos[index]["atraso"].toString(),
                                      formatter
                                          .format(datos[index]["cuota"])
                                          .split(".")[0],
                                      formatter.format(datos[index]["interes"]),
                                      formatter.format(datos[index]["abono"]),
                                      formatter
                                          .format(datos[index]["I.Moratorio"]),
                                      formatter
                                          .format(datos[index]["I.punitorio"])
                                    ];
                                  } else {
                                    return [];
                                  }
                                })))
                      ]));
                },
              ),
            ]));

    return pdf.save();
  }

  static Future<Uint8List> buildHistorialPersonal(BuildContext context,
      List<PrestamosModel> prestamosModel, String nombre) {
    final pdf = pw.Document();
    final f = DateFormat('dd-MM-yyyy');
    final formatter = intl.NumberFormat.decimalPattern();
    final List<String> headersData = [
      "Nro",
      "Vencimiento",
      "Estado",
      "Cuotas",
      "Interes",
    ];

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
          pw.Text("Historial de Prestamos",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
          pw.SizedBox(height: 10),
          pw.Text(f.format(DateTime.now()),
              style: const pw.TextStyle(fontSize: 17)),
          pw.SizedBox(height: 5),
          pw.Divider(),
          pw.SizedBox(height: 5),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Text(
                "Cantidad de Prestamos: ${prestamosModel.length.toString()}"),
            pw.SizedBox(width: 15),
            pw.Text("Cliente: $nombre",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ]),
          pw.SizedBox(height: 35),
          pw.ListView.builder(
            itemCount: prestamosModel.length,
            itemBuilder: (ctx, i) {
              final datos = json.decode(prestamosModel[i].data);
              return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 15),
                  child: pw.ListView(children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Nro: ${prestamosModel[i].id}",
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text("FECHA:   ${prestamosModel[i].fecha}",
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(
                              "Total:   ${formatter.format(prestamosModel[i].totalAPagar)} Gs",
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(
                              "Interes:   ${formatter.format(prestamosModel[i].totalInteres)} Gs",
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ]),
                    pw.SizedBox(height: 10),
                    pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Table.fromTextArray(
                            columnWidths: {
                              0: const pw.FractionColumnWidth(0.035),
                              1: const pw.FractionColumnWidth(0.070),
                              2: const pw.FractionColumnWidth(0.070),
                              3: const pw.FractionColumnWidth(0.070),
                              4: const pw.FractionColumnWidth(0.070)
                            },
                            cellAlignment: pw.Alignment.center,
                            headers: List<String>.generate(headersData.length,
                                (index) => headersData[index]),
                            data: List<List<String>>.generate(datos.length,
                                (index) {
                              return [
                                datos[index]["Nro"],
                                datos[index]["fecha"],
                                datos[index]["quitado"],
                                formatter
                                    .format(datos[index]["cuota"])
                                    .split(".")[0],
                                formatter
                                    .format(datos[index]["interes"])
                                    .split(".")[0],
                              ];
                            })))
                  ]));
            },
          ),
        ])
      ],
    ));

    return pdf.save();
  }

  static Future<Uint8List> builListadoClientes(
      BuildContext context, List<ArchivesModel> clientes) {
    final pdf = pw.Document();
    final f = DateFormat('dd-MM-yyyy');
    final List<String> header = ["Codigo", "Nombre", "Documento", "Telefono"];

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Column(children: [
          pw.Text("Listado de Clientes",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
          pw.SizedBox(height: 10),
          pw.Text(f.format(DateTime.now()),
              style: const pw.TextStyle(fontSize: 15)),
          pw.SizedBox(height: 10),
          pw.Divider(),
          pw.Padding(
              padding: const pw.EdgeInsets.all(20),
              child: pw.Text("Cantidad de Clientes: ${clientes.length}")),
          pw.SizedBox(height: 15),
          pw.Table.fromTextArray(
              cellAlignment: pw.Alignment.center,
              headers: List<String>.generate(
                  header.length, (index) => header[index]),
              data: List<List<String>>.generate(clientes.length, (i) {
                return [
                  clientes[i].idCliente!,
                  clientes[i].nombre,
                  clientes[i].cedula.toString(),
                  clientes[i].telefono,
                ];
              }))
        ])
      ],
    ));

    return pdf.save();
  }
}
