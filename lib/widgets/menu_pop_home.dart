import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/bloc/prestamos/prestamos_bloc.dart';
import 'package:my_app/helpers/build_historiales.dart';
import 'package:my_app/helpers/navegate_fadein.dart';
import 'package:my_app/models/prestamos_model.dart';
import 'package:my_app/pages/pdf_view.dart';

class MenuPopHome extends StatefulWidget {
  const MenuPopHome({
    super.key,
  });

  @override
  State<MenuPopHome> createState() => _MenuPopHomeState();
}

class _MenuPopHomeState extends State<MenuPopHome> {
  DateTime initialDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final logiBloc = BlocProvider.of<LoginBloc>(context);
    final prestamosBloc = BlocProvider.of<PrestamosBloc>(context);

    return PopupMenuButton(
        icon: const Icon(
          Icons.add_chart_outlined,
          color: Colors.black,
          size: 25,
        ),
        onSelected: (int selectedValue) async {
          if (selectedValue == 0) {
            DateTimeRange dateRange = DateTimeRange(
                start: DateTime(2022, 7, 5), end: DateTime(2022, 12, 24));

            DateTimeRange? newDateRange = await showDateRangePicker(
                initialDateRange: dateRange,
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));

            if (newDateRange == null) return;
            final List<PrestamosModel> resto =
                await prestamosBloc.cargarPorFecha(
                    newDateRange.start.millisecondsSinceEpoch,
                    newDateRange.end.millisecondsSinceEpoch);

            if (mounted) {
              Navigator.push(
                  context,
                  navegarFadeIn(
                      context,
                      PDFViewPage(
                          data: await BuildHistoriales.buildHistorialPrestamo(
                              context,
                              resto,
                              newDateRange.start,
                              newDateRange.end))));
            }
          }
          if (selectedValue == 1 && mounted) {
            final pdfView = await BuildHistoriales.builListadoClientes(
                context, logiBloc.state.archives);
            if (mounted) {
              Navigator.push(
                  context, navegarFadeIn(context, PDFViewPage(data: pdfView)));
            }
          }
        },
        itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text(
                  'Historial de Prestamos Pagados',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text(
                  'Listado de Clientes',
                  style: TextStyle(fontSize: 15),
                ),
              )
            ]);
  }
}
