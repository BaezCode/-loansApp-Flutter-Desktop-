// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/helpers/build_pdf.dart';
import 'package:my_app/helpers/navegate_fadein.dart';
import 'package:my_app/pages/pdf_view.dart';
import 'package:my_app/shared/preferencias_usuario.dart';
import 'package:intl/intl.dart' as intl;

class CustomWidgets {
  CustomWidgets._();

  static buildSnackbar(BuildContext context, String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.grey[900],
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
              Icon(
                icon,
                color: Colors.blue[700],
              )
            ],
          ),
          duration: const Duration(milliseconds: 1500)),
    );
  }

  static buildPlanDiario(BuildContext context, List<Map<String, dynamic>> data,
      String nombre, double valor) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Dias a Generar"),
            content: CupertinoTextField(
              onSubmitted: (value) async {
                Navigator.pop(context);
                final pdfView = await BuildPDF.buildDiario(
                    context, data, nombre, int.parse(value), valor);
                Navigator.push(context,
                    navegarFadeIn(context, PDFViewPage(data: pdfView)));
              },
            ),
          );
        });
  }

  static buildSenha(BuildContext context) {
    final prefs = PreferenciasUsuario();

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Nueva Contraseña"),
            content: CupertinoTextField(
              obscureText: true,
              onSubmitted: (value) {
                prefs.password = value;
                Navigator.pop(context);
                CustomWidgets.buildSnackbar(
                    context, "Cambiada Correctamente", Icons.check);
              },
            ),
          );
        });
  }

  static buildUsuario(BuildContext context) {
    final prefs = PreferenciasUsuario();

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Nueva Usuario"),
            content: CupertinoTextField(
              onSubmitted: (value) {
                prefs.nombreUsuario = value;
                Navigator.pop(context);
                CustomWidgets.buildSnackbar(
                    context, "Cambiada Correctamente", Icons.check);
              },
            ),
          );
        });
  }

  static buildsenhaEmergencia(BuildContext context) {
    final prefs = PreferenciasUsuario();

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Contraseña de Emergencia"),
            content: CupertinoTextField(
              obscureText: true,
              onSubmitted: (value) {
                if (prefs.emergencia == value) {
                  Navigator.pushReplacementNamed(context, "home");
                  CustomWidgets.buildSnackbar(
                      context, "Bienvenido", Icons.check);
                } else {
                  CustomWidgets.buildSnackbar(context, "Contraseña Incorrecta",
                      Icons.sentiment_dissatisfied);
                }
              },
            ),
          );
        });
  }

  static datePickerDIalog(BuildContext context) {
    final intl.DateFormat formatter = DateFormat('dd-MM-yyyy');
    DateTime initialDate = DateTime.now();
    DateTime secondDate = DateTime.now();
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Seleccionar Fechas"),
                  content: SizedBox(
                    height: 150,
                    width: 350,
                    child: ListView(
                      children: [
                        ListTile(
                          trailing: Text(
                            formatter.format(initialDate),
                            style: const TextStyle(color: Colors.blue),
                          ),
                          onTap: () async {
                            final newDate = await showDatePicker(
                              locale: const Locale("es"),
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2035),
                            );
                            setState(() => initialDate = newDate!);
                          },
                          title: const Text(
                            "Desde - Fecha",
                            style: TextStyle(fontSize: 15),
                          ),
                          leading: const Icon(
                            CupertinoIcons.time,
                            color: Colors.black,
                          ),
                        ),
                        ListTile(
                          trailing: Text(formatter.format(secondDate)),
                          onTap: () async {
                            final newDate = await showDatePicker(
                              locale: const Locale("es"),
                              context: context,
                              initialDate: secondDate,
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2035),
                            );
                            setState(() => secondDate = newDate!);
                          },
                          title: const Text(
                            "Hasta + Fecha",
                            style: TextStyle(fontSize: 15),
                          ),
                          leading: const Icon(
                            CupertinoIcons.time,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ));
            },
          );
        });
  }
}
