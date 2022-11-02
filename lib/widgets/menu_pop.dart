import 'package:flutter/material.dart';
import 'package:my_app/bloc/prestamos/prestamos_bloc.dart';
import 'package:my_app/helpers/build_pdf.dart';
import 'package:my_app/helpers/navegate_fadein.dart';
import 'package:my_app/pages/pdf_view.dart';
import 'package:intl/intl.dart' as intl;

class MenuPop extends StatefulWidget {
  final String nombre;
  final PrestamosState state;
  final DateTime date;
  const MenuPop(
      {super.key,
      required this.nombre,
      required this.state,
      required this.date});
  @override
  State<MenuPop> createState() => _MenuPopState();
}

class _MenuPopState extends State<MenuPop> {
  final formatter = intl.NumberFormat.decimalPattern();
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.add_chart_outlined,
        color: Colors.black,
        size: 25,
      ),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0 && mounted) {
          final pdfView = await BuildPDF.dowloadPlanPago(
            context,
            widget.state.data,
            widget.nombre,
            formatter.format(widget.state.totalInteres),
            formatter.format(widget.state.totalAPagar),
            widget.state.monto,
            widget.state.totalAPagar,
          );
          if (mounted) {
            Navigator.push(
                context, navegarFadeIn(context, PDFViewPage(data: pdfView)));
          }
        }
        if (selectedValue == 1 && mounted) {
          final pdfView = await BuildPDF.dowloadPlanPagoQuincenal(
              context,
              widget.state.data,
              widget.nombre,
              formatter.format(widget.state.totalInteres),
              formatter.format(widget.state.totalAPagar),
              widget.state.monto,
              widget.state.totalAPagar,
              widget.date);
          if (mounted) {
            Navigator.push(
                context, navegarFadeIn(context, PDFViewPage(data: pdfView)));
          }
        }
        if (selectedValue == 2 && mounted) {
          final pdfView = await BuildPDF.dowloadPlanPagoSemanal(
              context,
              widget.state.data,
              widget.nombre,
              formatter.format(widget.state.totalInteres),
              formatter.format(widget.state.totalAPagar),
              widget.state.monto,
              widget.state.totalAPagar,
              widget.date);
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
            'Plan Por Mes',
            style: TextStyle(fontSize: 15),
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: Text(
            'Plan Quincenal',
            style: TextStyle(fontSize: 15),
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text(
            'Plan Semanal',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
