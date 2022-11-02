import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/bloc/prestamos/prestamos_bloc.dart';
import 'package:my_app/datatables/prestamo_datasource.dart';
import 'package:intl/intl.dart' as intl;
import 'package:my_app/helpers/build_modificar_cuota.dart';
import 'package:my_app/helpers/build_pdf.dart';
import 'package:my_app/helpers/navegate_fadein.dart';
import 'package:my_app/helpers/snackbar.dart';
import 'package:my_app/pages/pdf_view.dart';
import 'package:my_app/widgets/menu_pop.dart';

class Tab2 extends StatefulWidget {
  const Tab2({
    Key? key,
  }) : super(key: key);

  @override
  State<Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  late PrestamosBloc prestamosBloc;
  late LoginBloc loginBloc;
  final formatter = intl.NumberFormat.decimalPattern();

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    prestamosBloc = BlocProvider.of<PrestamosBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    prestamosBloc.add(SetFechaMili(DateTime.now().millisecondsSinceEpoch));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<PrestamosBloc, PrestamosState>(
      builder: (context, state) {
        final usuario = state.archivesModel!;
        if (state.fecha.isNotEmpty) {
          DateTime tempDate = DateFormat("dd-MM-yyyy").parse(state.fecha);
          now = tempDate;
        }
        return BlocBuilder<PrestamosBloc, PrestamosState>(
          builder: (context, state) {
            return Container(
              decoration: buildBoxDecoration(),
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  ListTile(
                      trailing: SizedBox(
                        width: size.width * 0.60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Spacer(),
                            TextButton(
                                onPressed: () {
                                  loginBloc.selectedIndex(0, false);
                                },
                                child: const Text(
                                  "Atras",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15),
                                )),
                            TextButton(
                                onPressed: () async {
                                  final pdfView = await BuildPDF.dowloadPDF(
                                      context,
                                      usuario,
                                      formatter.format(state.totalAPagar),
                                      now);
                                  if (mounted) {
                                    Navigator.push(
                                        context,
                                        navegarFadeIn(context,
                                            PDFViewPage(data: pdfView)));
                                  }
                                },
                                child: const Text(
                                  "Generar Pagare",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15),
                                )),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                                onPressed: () async {
                                  CustomWidgets.buildPlanDiario(
                                      context,
                                      state.data,
                                      usuario.nombre,
                                      state.totalAPagar);
                                },
                                child: const Text("Plan de Pago Diario",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))),
                            const SizedBox(
                              width: 20,
                            ),
                            MenuPop(
                              state: state,
                              nombre: usuario.nombre,
                              date: now,
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(
                        "C.I: ${usuario.cedula}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        usuario.nombre,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      leading: const Icon(
                        Icons.account_circle,
                        size: 45,
                        color: Colors.black,
                      )),
                  Row(
                    children: [
                      Text(
                        "    Lugar Donde Trabaja : ${usuario.trabaja} ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _panelDatos(state),
                  const SizedBox(
                    height: 30,
                  ),
                  _panelDatos2(state),
                  const SizedBox(
                    height: 15,
                  ),
                  PaginatedDataTable(columns: [
                    const DataColumn(label: Text('NRO.')),
                    const DataColumn(label: Text('Accion')),
                    const DataColumn(label: Text('Fecha De Pago')),
                    const DataColumn(label: Text('Vencimiento')),
                    const DataColumn(label: Text('Dias atraso')),
                    DataColumn(
                        label: TextButton(
                            onPressed: () {
                              CustomModificar.customModificarCuota(
                                  context, state.data, usuario);
                            },
                            child: const Text('Cuota a Pagar'))),
                    DataColumn(
                        label: TextButton(
                            onPressed: () {
                              CustomModificar.customModificarIntereses(
                                  context, state.data, usuario);
                            },
                            child: const Text('Interes'))),
                    const DataColumn(label: Text('Abono a Capital')),
                    const DataColumn(label: Text('Saldo final')),
                    const DataColumn(label: Text('I. Moratorio')),
                    const DataColumn(label: Text('I. Punitorio')),
                  ], source: PrestamoDataSources(context, state.data, usuario)),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _panelDatos2(PrestamosState state) {
    final size = MediaQuery.of(context).size;
    final intl.DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Colors.black,
            minWidth: 1,
            child: Text(
              formatted,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () async {
              final newDate = await showDatePicker(
                locale: const Locale("es"),
                context: context,
                initialDate: now,
                firstDate: DateTime(2010),
                lastDate: DateTime(2035),
              );
              if (newDate == null) return;
              setState(() => now = newDate);
              prestamosBloc.add(SetFechaMili(newDate.millisecondsSinceEpoch));
            }),
        const SizedBox(
          width: 25,
        ),
        MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Colors.black,
            minWidth: 1,
            child: const Text(
              "Generar Numeros",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              if (loginBloc.state.isUpdate) {
                CustomWidgets.buildSnackbar(context,
                    "No puedes modificar prestamos guardados", Icons.error);
              } else {
                prestamosBloc.generate();
              }
            }),
        SizedBox(
          width: size.width * 0.050,
        ),
        const Text(
          "I. Punitorio %",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          padding: const EdgeInsets.all(3),
          height: 50,
          width: size.width * 0.10,
          child: TextFormField(
            initialValue: state.interesPunitorio.toString(),
            onChanged: (value) {
              if (value.isEmpty) {
              } else {
                prestamosBloc.add(
                    SetIntereses(state.interesMoratorio, double.parse(value)));
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.dialpad_outlined,
                  size: 17,
                ),
                border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget _panelDatos(PrestamosState state) {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Interes Mensual %",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(
          width: 2,
        ),
        Container(
          padding: const EdgeInsets.all(3),
          height: 50,
          width: size.width * 0.10,
          child: TextFormField(
            initialValue: state.interes.toString(),
            onChanged: (value) {
              if (value.isEmpty) {
              } else {
                prestamosBloc.add(SetPrestamo(
                    double.parse(value), state.cuotas, state.monto));
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.dialpad_outlined,
                  size: 17,
                ),
                border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        const Text(
          "Meses",
          style: TextStyle(),
        ),
        const SizedBox(
          width: 8,
        ),
        Container(
          padding: const EdgeInsets.all(3),
          height: 50,
          width: size.width * 0.10,
          child: TextFormField(
            initialValue: state.cuotas.toString(),
            onChanged: (value) {
              if (value.isEmpty) {
              } else {
                prestamosBloc.add(
                    SetPrestamo(state.interes, int.parse(value), state.monto));
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                suffixIcon: Icon(Icons.panorama_vertical_select_rounded),
                border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        const Text(
          "Monto a Recibir",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          padding: const EdgeInsets.all(3),
          height: 55,
          width: size.width * 0.10,
          child: TextFormField(
            initialValue: state.monto.toString(),
            onChanged: (value) {
              if (value.isEmpty) {
              } else {
                prestamosBloc.add(
                    SetPrestamo(state.interes, state.cuotas, int.parse(value)));
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(19),
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                suffixIcon: Icon(Icons.panorama_vertical_select_rounded),
                border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        const Text(
          "I. Moratorio %",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          padding: const EdgeInsets.all(3),
          height: 50,
          width: size.width * 0.10,
          child: TextFormField(
            initialValue: state.interesMoratorio.toString(),
            onChanged: (value) {
              if (value.isEmpty) {
              } else {
                prestamosBloc.add(
                    SetIntereses(double.parse(value), state.interesPunitorio));
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.dialpad_outlined,
                  size: 17,
                ),
                border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
          ]);
}
