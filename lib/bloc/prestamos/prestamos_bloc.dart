import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:my_app/models/archives_model.dart';
import 'package:my_app/models/prestamos_model.dart';
import 'package:my_app/services/db_prestamo.dart';

part 'prestamos_event.dart';
part 'prestamos_state.dart';

class PrestamosBloc extends Bloc<PrestamosEvent, PrestamosState> {
  double abono = 0;
  double interes = 0;
  double interesMoratorio = 0;
  double interesPunitorio = 0;
  double cuota = 0;
  double monto = 0;
  double totalGeneral = 0;
  double totalInteres = 0;
  List<PrestamosModel> prestamos = [];

  PrestamosBloc() : super(PrestamosState()) {
    on<SetPrestamo>((event, emit) {
      emit(state.copyWith(
          interes: event.interes, cuotas: event.cuotas, monto: event.monto));
    });

    on<SetUser>((event, emit) {
      emit(state.copyWith(archivesModel: event.archivesModel));
    });

    on<SetList>((event, emit) {
      emit(state.copyWith(
        data: event.data,
      ));
    });
    on<SetTotalInteres>((event, emit) {
      emit(state.copyWith(
        totalInteres: event.totalInteres,
      ));
    });
    on<SetTotalApagar>((event, emit) {
      emit(state.copyWith(
        totalAPagar: event.totalAPagar,
      ));
    });

    on<SetTotales>((event, emit) {
      emit(state.copyWith(
          totalAPagar: event.totalAPagar, totalInteres: event.totalInteres));
    });

    on<SetIntereses>((event, emit) {
      emit(state.copyWith(
          interesMoratorio: event.interesMoratorio,
          interesPunitorio: event.interesPunitorio));
    });

    on<CargarPrestamos>((event, emit) {
      emit(state.copyWith(prestamos: event.prestamos));
    });

    on<ChargeAllData>((event, emit) {
      emit(state.copyWith(
          cuotas: event.cuotas,
          interes: event.interes,
          monto: event.monto,
          data: event.data,
          archivesModel: event.archivesModel,
          totalAPagar: event.totalAPagar,
          totalInteres: event.totalInteres,
          fecha: event.fecha,
          fechaMili: event.fechaMili,
          id: event.id));
    });

    on<ClearAll>((event, emit) {
      emit(state.copyWith(
          cuotas: 0,
          interes: 0,
          monto: 0,
          data: [],
          totalAPagar: 00,
          totalInteres: 00));
    });
    on<SetFechaMili>((event, emit) {
      emit(state.copyWith(fechaMili: event.fechaMili));
    });
  }

  void borrarPrestamo(int id) async {
    await DBPrestamo.db.deletePrestamo(id);
  }

  Future<bool> update(ArchivesModel archivesModel, datares) async {
    final String data = jsonEncode(datares);
    final prestmosModel = PrestamosModel(
        interesPunitorio: state.interesPunitorio,
        id: state.id,
        interesMoratorio: state.interesMoratorio,
        idCliente: state.archivesModel!.idCliente!,
        monto: state.monto,
        interes: state.interes,
        cuotas: state.cuotas,
        nombre: archivesModel.nombre,
        totalAPagar: state.totalAPagar,
        totalInteres: state.totalInteres,
        data: data,
        fecha: state.fecha,
        fechaMili: state.fechaMili);
    await DBPrestamo.db.updatePrestamo(prestmosModel);
    add(SetList(datares));
    return true;
  }

  Future<bool> saveData(
      PrestamosState state, ArchivesModel archivesModel) async {
    final String data = jsonEncode(state.data);

    final prestmosModel = PrestamosModel(
        interesMoratorio: state.interesMoratorio,
        interesPunitorio: state.interesPunitorio,
        idCliente: archivesModel.idCliente!,
        monto: state.monto,
        interes: state.interes,
        cuotas: state.cuotas,
        nombre: archivesModel.nombre,
        totalAPagar: state.totalAPagar,
        totalInteres: state.totalInteres,
        data: data,
        fecha: state.data[0]["fecha"],
        fechaMili: state.fechaMili);
    await DBPrestamo.db.nuevoFolder(prestmosModel);

    return true;
  }

  Future<List<PrestamosModel>> cargarPorFecha(int primer, int segunda) async {
    prestamos.clear();
    final folders = await DBPrestamo.db.getPrestamoPorFecha(primer, segunda);
    prestamos = [...folders];
    return prestamos;
  }

  Future<void> cargarPrestamosPorID(String id) async {
    prestamos.clear();
    final folders = await DBPrestamo.db.getScansPorID(id);
    prestamos = [...folders];
    add(CargarPrestamos(prestamos));
  }

  void generate() {
    final myList = List.generate(state.cuotas, (index) {
      DateTime now = DateTime.now();
      final interesNew = state.interes / 100;
      final interesMoratorioNew = state.interesMoratorio / 100;
      final fecha = Jiffy(now.add(const Duration(
        days: 1,
      ))).add(months: index + 1).format("dd-MM-yyyy");
      int dia = 0;
      final dayNow = DateTime.now();
      DateTime tempDate = DateFormat("dd-MM-yyyy").parse(fecha);
      if (dayNow.difference(tempDate).inDays.isNegative == false) {
        dia = dayNow.difference(tempDate).inDays;
      }

      if (index == 0) {
        final realDia = dia - 3;

        monto = state.monto.toDouble();
        abono = state.monto / state.cuotas;
        interes = state.monto * interesNew;
        interesMoratorio = dia > 4
            ? interes * interesMoratorioNew * dia
            : interes * interesMoratorioNew * realDia;
        cuota = dia < 3 ? abono + interes : abono + interes + interesMoratorio;
        totalGeneral = cuota;
        totalInteres = interes;
      } else {
        final realDia = dia - 3;
        monto = monto - abono;
        cuota = dia < 3 ? abono + interes : abono + interes + interesMoratorio;
        totalGeneral = totalGeneral + cuota;
        totalInteres = totalInteres + interes;
        interesMoratorio = dia > 4
            ? interes * interesMoratorioNew * dia
            : interes * interesMoratorioNew * realDia;
      }
      return {
        'Nro': "${index + 1} /${state.cuotas}",
        'quitado': "Pendiente",
        'Fecha de Pago': '--',
        'fecha': fecha,
        "interes": interes,
        "Saldo": index == 0 ? state.monto : monto,
        "cuota": cuota,
        "abono": abono,
        "atraso": dia,
        "I.Moratorio": dia < 3 ? 0.0 : interesMoratorio,
        "I.punitorio": dia < 3 ? 0.0 : interesPunitorio,
      };
    });

    add(SetTotales(totalInteres, totalGeneral));
    add(SetList(myList));
    abono = 0;
    interes = 0;
    cuota = 0;
    monto = 0;
    totalGeneral = 0;
    totalInteres = 0;
  }

  void clearData() {
    add(SetPrestamo(0, 0, 0));
  }
}
