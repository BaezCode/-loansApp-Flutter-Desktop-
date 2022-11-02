import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:my_app/models/archives_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart' as intl;

class BuildPDF {
  static Future<Uint8List> dowloadPDF(BuildContext context,
      ArchivesModel usuario, String monto, DateTime now) async {
    final size = MediaQuery.of(context).size;
    final f = DateFormat('dd-MM-yyyy');
    final pdf = pw.Document();
    final assetImage = pw.MemoryImage(
      (await rootBundle.load('images/ofi.jpeg')).buffer.asUint8List(),
    );

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Row(children: [
          pw.Container(
            height: size.height * 0.15,
            child: pw.Image(assetImage),
          ),
          pw.Spacer(),
          pw.Column(children: [
            pw.Center(
                child: pw.Container(
                    margin: pw.EdgeInsets.all(15.0),
                    padding: pw.EdgeInsets.all(3.0),
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text("Pagaré A la orden",
                        style: const pw.TextStyle(fontSize: 17)))),
            pw.Center(
                child: pw.Container(
                    margin: pw.EdgeInsets.all(15.0),
                    padding: pw.EdgeInsets.all(3.0),
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text("$monto Gs",
                        style: const pw.TextStyle(fontSize: 17)))),
            pw.SizedBox(height: size.height * 0.020),
            pw.Center(
                child: pw.Text("Vencimiento:___________________",
                    style: const pw.TextStyle(fontSize: 14))),
            pw.SizedBox(height: size.height * 0.020),
            pw.Center(
                child: pw.Text("Pedro Juan Caballero, ${f.format(now)} ",
                    style: const pw.TextStyle(fontSize: 14))),
          ]),
        ]),
        pw.SizedBox(height: size.height * 0.030),
        pw.Center(
            child: pw.Text(
                "Pagaré(mos) a la vista y a la orden de _________________________________________  en su domicilio de la ciudad de Pedro Juan Caballero, ${usuario.direccion}, sin protesto la suma de ________________________________________ ",
                style: const pw.TextStyle(fontSize: 11))),
        pw.SizedBox(height: 10),
        pw.Center(
            child: pw.Text(
                'Por igual valor recibido en efectivo a mi (nuestra) entera conformidad. A los efectos legales y procesales emergentes de este documento se fija domicilio en la ciudad de Pedro Juan Caballero en la casa de la Cnel. Valois Rivarola, 272.----------------------------------------------------------------',
                style: pw.TextStyle(fontSize: 11))),
        pw.SizedBox(height: 10),
        pw.Center(
            child: pw.Text(
                'Este pagaré generará un interés compensatorio del (     ) % anual desde la fecha del libramiento hasta su presentación al cobro. La falta de pago de este pagaré a su presentación producirá la constitución en mora y genera de pleno derecho, intereses moratorios cuyas tasas serán las mismas tasas pactadas originariamente como interés compensatorio y será computada desde el día de la mora hasta el día del pago efectivo de total de la obligación principal y sus intereses, sin que ello implique novación, prórroga o espera. El interés moratorio será calculado sobre el saldo de la deuda vencida y en ningún caso podrá capitalizarse intereses moratorios ni punitorios. La falta de pago de este pagaré a su vencimiento, además del interés moratorio mencionado, genera de pleno derecho un interés punitorio anual que será del treinta por ciento (30%) de la tasa a percibirse en concepto de interés moratorio, de conformidad a las disposiciones de la Ley N° 2339 de fecha 26 de diciembre de 2003, que modifica el Art. 44 de la Ley N° 489/95.-----------------------------------',
                style: pw.TextStyle(fontSize: 11))),
        pw.SizedBox(height: 10),
        pw.Center(
            child: pw.Text(
                'Para el caso de ejecución judicial, el portador de este Pagaré queda autorizado a iniciar la ejecución por el monto del Capital e intereses moratorios y punitorios liquidados a la fecha de su iniciación, sin perjuicio de la liquidación prevista en los Arts. 475 y 501 del C.P.C.----------------',
                style: pw.TextStyle(fontSize: 11))),
        pw.SizedBox(height: 10),
        pw.Center(
            child: pw.Text(
                "El simple vencimiento establecerá la mora, autorizando la inclusión de mi Nombre Personal o Razón Social que represento a la base de datos de Inforcomf, conforme lo establecido en la Ley 1682/01, como también para que se pueda proveer la información a terceros interesados. ---------",
                style: const pw.TextStyle(fontSize: 11))),
        pw.SizedBox(height: 10),
        pw.Center(
            child: pw.Text(
                "Todas las partes intervinientes en este documento se someten a la jurisdicción y competencia de los Jueces y Tribunales de la ciudad de Pedro Juan Caballero y declaran prorrogada desde ya cualquier otra que pudiera corresponder. ------------------------------------------------------------------- ",
                style: const pw.TextStyle(fontSize: 11))),
        pw.SizedBox(height: 10),
        pw.Center(
            child: pw.Text(
                "Se deja constancia que los abajo firmantes suscriben en nombre de la sociedad conyugal y así mismo a nombre propio, comprometiéndose sus bienes propios y gananciales, ya se traten de actos de administración o disposición. ---------------------------------------------------------------------",
                style: const pw.TextStyle(fontSize: 11))),
        pw.SizedBox(height: size.height * 0.050),
        pw.Row(children: [
          pw.Container(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                pw.Text("DEUDOR"),
                pw.SizedBox(height: 5),
                pw.Text(usuario.nombre),
                pw.SizedBox(height: 10),
                pw.Text("Firma: _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ "),
                pw.SizedBox(height: 10),
                pw.Text("C.I. Nro./R.U.C.:  ${usuario.cedula} "),
                pw.SizedBox(height: 10),
                pw.Text("Aclaración de firma: _ _ _ _ _ _ _ _ _ _ _  "),
              ])),
          pw.Spacer(),
          pw.Container(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                pw.Text("CO DEUDOR"),
                pw.SizedBox(height: 5),
                pw.Text(usuario.referencia!),
                pw.SizedBox(height: 10),
                pw.Text("Firma: _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ "),
                pw.SizedBox(height: 10),
                pw.Text("C.I. Nro./R.U.C.: _ _ _ _ _ _ _ _ _ _ _ _ _ "),
                pw.SizedBox(height: 10),
                pw.Text("Aclaración de firma: _ _ _ _ _ _ _ _ _ _ _  "),
              ]))
        ])
      ],
    ));

    return pdf.save();
  }

  static Future<Uint8List> dowloadPlanPagoSemanal(
      BuildContext context,
      List<Map<String, dynamic>> data,
      String nombre,
      String interes,
      String montoTotal,
      int asi,
      double totaGeneral,
      DateTime date) async {
    final size = MediaQuery.of(context).size;
    final pdf = pw.Document();
    final assetImage = pw.MemoryImage(
      (await rootBundle.load('images/ofi.jpeg')).buffer.asUint8List(),
    );
    final List<String> datos = ["Nro", "FECHA", "MONTO"];
    final List<String> segundo = [
      "TOTAL",
      "DESCUENTO(GASTOS ADM. + INTERES+ IVA)",
      "MONTO A Retirar"
    ];
    final formatter = intl.NumberFormat.decimalPattern();

    int semanas = 0;
    int cuotas = data.length * 4;

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Center(
          child: pw.Container(
            height: size.height * 0.10,
            child: pw.Image(assetImage),
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Center(
          child:
              pw.Text("Plan de Pago", style: const pw.TextStyle(fontSize: 15)),
        ),
        pw.SizedBox(height: 15),
        pw.Center(
          child: pw.Text("Cliente", style: const pw.TextStyle(fontSize: 15)),
        ),
        pw.SizedBox(height: 15),
        pw.Center(
          child: pw.Text(nombre, style: const pw.TextStyle(fontSize: 13)),
        ),
        pw.SizedBox(height: 15),
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FractionColumnWidth(0.035),
              1: const pw.FractionColumnWidth(0.055)
            },
            headers:
                List<String>.generate(datos.length, (index) => datos[index]),
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.centerRight,
            data: List<List<String>>.generate(cuotas, (index) {
              semanas = index == 0 ? semanas : semanas + 1;
              final montoDate = totaGeneral / cuotas;
              return [
                "${index + 1} / $cuotas",
                Jiffy(date).add(weeks: semanas).format("dd-MM-yyyy"),
                "${formatter.format(montoDate.round())} ",
              ];
            })),
        pw.SizedBox(height: 30),
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FractionColumnWidth(0.075),
              1: const pw.FractionColumnWidth(0.20)
            },
            headers: List<String>.generate(
                segundo.length, (index) => segundo[index]),
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.centerRight,
            data: List<List<String>>.generate(
                1,
                (index) => [
                      montoTotal,
                      interes,
                      formatter.format(asi),
                    ])),
        pw.SizedBox(height: 30),
        pw.Center(
          child: pw.Text("________________________"),
        ),
        pw.SizedBox(height: 20),
        pw.Center(
          child: pw.Text("FIRMA DE CLIENTE"),
        ),
      ],
    ));

    return pdf.save();
  }

  static Future<Uint8List> dowloadPlanPagoQuincenal(
      BuildContext context,
      List<Map<String, dynamic>> data,
      String nombre,
      String interes,
      String montoTotal,
      int asi,
      double totaGeneral,
      DateTime date) async {
    final size = MediaQuery.of(context).size;
    final pdf = pw.Document();
    final assetImage = pw.MemoryImage(
      (await rootBundle.load('images/ofi.jpeg')).buffer.asUint8List(),
    );
    final List<String> datos = ["Nro", "FECHA", "MONTO"];
    final List<String> segundo = [
      "TOTAL",
      "DESCUENTO(GASTOS ADM. + INTERES+ IVA)",
      "MONTO A Retirar"
    ];
    final formatter = intl.NumberFormat.decimalPattern();

    int dias = 15;
    int cuotas = data.length * 2;

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Center(
          child: pw.Container(
            height: size.height * 0.10,
            child: pw.Image(assetImage),
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Center(
          child:
              pw.Text("Plan de Pago", style: const pw.TextStyle(fontSize: 15)),
        ),
        pw.SizedBox(height: 15),
        pw.Center(
          child: pw.Text("Cliente", style: const pw.TextStyle(fontSize: 15)),
        ),
        pw.SizedBox(height: 15),
        pw.Center(
          child: pw.Text(nombre, style: const pw.TextStyle(fontSize: 13)),
        ),
        pw.SizedBox(height: 15),
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FractionColumnWidth(0.035),
              1: const pw.FractionColumnWidth(0.055)
            },
            headers:
                List<String>.generate(datos.length, (index) => datos[index]),
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.centerRight,
            data: List<List<String>>.generate(cuotas, (index) {
              dias = index == 0 ? dias : dias + 15;
              final montoDate = totaGeneral / cuotas;
              return [
                "${index + 1} / $cuotas",
                Jiffy(date).add(days: dias).format("dd-MM-yyyy"),
                "${formatter.format(montoDate.round())} ",
              ];
            })),
        pw.SizedBox(height: 30),
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FractionColumnWidth(0.075),
              1: const pw.FractionColumnWidth(0.20)
            },
            headers: List<String>.generate(
                segundo.length, (index) => segundo[index]),
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.centerRight,
            data: List<List<String>>.generate(
                1,
                (index) => [
                      montoTotal,
                      interes,
                      formatter.format(asi),
                    ])),
        pw.SizedBox(height: 30),
        pw.Center(
          child: pw.Text("________________________"),
        ),
        pw.SizedBox(height: 20),
        pw.Center(
          child: pw.Text("FIRMA DE CLIENTE"),
        ),
      ],
    ));

    return pdf.save();
  }

  static Future<Uint8List> dowloadPlanPago(
      BuildContext context,
      List<Map<String, dynamic>> data,
      String nombre,
      String interes,
      String montoTotal,
      int asi,
      double totaGeneral) async {
    final size = MediaQuery.of(context).size;
    final pdf = pw.Document();
    final assetImage = pw.MemoryImage(
      (await rootBundle.load('images/ofi.jpeg')).buffer.asUint8List(),
    );
    final List<String> datos = ["Nro", "FECHA", "MONTO"];
    final List<String> segundo = [
      "TOTAL",
      "DESCUENTO(GASTOS ADM. + INTERES+ IVA)",
      "MONTO A Retirar"
    ];
    final formatter = intl.NumberFormat.decimalPattern();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Center(
          child: pw.Container(
            height: size.height * 0.10,
            child: pw.Image(assetImage),
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Center(
          child:
              pw.Text("Plan de Pago", style: const pw.TextStyle(fontSize: 15)),
        ),
        pw.SizedBox(height: 15),
        pw.Center(
          child: pw.Text("Cliente", style: const pw.TextStyle(fontSize: 15)),
        ),
        pw.SizedBox(height: 15),
        pw.Center(
          child: pw.Text(nombre, style: const pw.TextStyle(fontSize: 13)),
        ),
        pw.SizedBox(height: 15),
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FractionColumnWidth(0.035),
              1: const pw.FractionColumnWidth(0.055)
            },
            headers:
                List<String>.generate(datos.length, (index) => datos[index]),
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.centerRight,
            data: List<List<String>>.generate(data.length, (index) {
              return [
                data[index]["Nro"],
                data[index]["fecha"],
                "${formatter.format(data[index]["cuota"])} ",
              ];
            })),
        pw.SizedBox(height: 30),
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FractionColumnWidth(0.075),
              1: const pw.FractionColumnWidth(0.20)
            },
            headers: List<String>.generate(
                segundo.length, (index) => segundo[index]),
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.centerRight,
            data: List<List<String>>.generate(
                1,
                (index) => [
                      montoTotal,
                      interes,
                      formatter.format(asi),
                    ])),
        pw.SizedBox(height: 30),
        pw.Center(
          child: pw.Text("________________________"),
        ),
        pw.SizedBox(height: 20),
        pw.Center(
          child: pw.Text("FIRMA DE CLIENTE"),
        ),
      ],
    ));

    return pdf.save();
  }

  static Future<Uint8List> buildDiario(
      BuildContext context,
      List<Map<String, dynamic>> data,
      String nombre,
      int dias,
      double totaGeneral) {
    final List<String> datos = [
      "N.",
      "FECHA",
      "Monto a Pagar:",
      "COBRADO POR:"
    ];
    final formatter = intl.NumberFormat.decimalPattern();
    final pdf = pw.Document();
    final data = totaGeneral / dias;
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FractionColumnWidth(0.075),
              1: const pw.FractionColumnWidth(0.20)
            },
            headers:
                List<String>.generate(datos.length, (index) => datos[index]),
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.centerRight,
            data: List<List<String>>.generate(
                dias,
                (index) => [
                      '${index + 1}',
                      Jiffy().add(days: index).format("dd-MM-yyyy"),
                      formatter.format(data).split(".")[0]
                    ])),
      ],
    ));

    return pdf.save();
  }
}
