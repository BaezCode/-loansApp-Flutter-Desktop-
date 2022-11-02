import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/prestamos/prestamos_bloc.dart';
import 'package:my_app/models/archives_model.dart';

class CustomModificar {
  CustomModificar._();

  static customModificarCuota(
    BuildContext context,
    List<Map<String, dynamic>> mapa,
    ArchivesModel archivesModel,
  ) {
    final prestamosBloc = BlocProvider.of<PrestamosBloc>(context);
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Modificar Cuota"),
            content: TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(19),
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onFieldSubmitted: (este) async {
                if (este.isEmpty) {
                } else {
                  final cuota = double.parse(este);
                  for (var element in mapa) {
                    element['cuota'] = cuota;
                  }

                  prestamosBloc.update(archivesModel, mapa);
                  prestamosBloc.add(SetTotalApagar(cuota * mapa.length));

                  Navigator.pop(context);
                }
              },
            ),
          );
        });
  }

  static customModificarIntereses(
    BuildContext context,
    List<Map<String, dynamic>> mapa,
    ArchivesModel archivesModel,
  ) {
    final prestamosBloc = BlocProvider.of<PrestamosBloc>(context);
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Modificar Intereses"),
            content: TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(19),
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onFieldSubmitted: (este) async {
                if (este.isEmpty) {
                } else {
                  final interes = double.parse(este);
                  for (var element in mapa) {
                    element['interes'] = interes;
                  }

                  prestamosBloc.update(archivesModel, mapa);
                  prestamosBloc.add(SetTotalInteres(interes * mapa.length));

                  Navigator.pop(context);
                }
              },
            ),
          );
        });
  }
}
