part of 'prestamos_bloc.dart';

class PrestamosState {
  final double interes;
  final double interesMoratorio;
  final double interesPunitorio;
  final int cuotas;
  final int monto;
  final ArchivesModel? archivesModel;
  final List<Map<String, dynamic>> data;
  final List<PrestamosModel> prestamos;
  final double totalAPagar;
  final double totalInteres;
  final String fecha;
  final int fechaMili;
  final int id;

  PrestamosState({
    this.interes = 00,
    this.interesMoratorio = 00,
    this.interesPunitorio = 00,
    this.cuotas = 1,
    this.monto = 00,
    this.archivesModel,
    this.data = const [],
    this.prestamos = const [],
    this.totalAPagar = 00,
    this.totalInteres = 00,
    this.fecha = '',
    this.fechaMili = 0,
    this.id = 0,
  });

  PrestamosState copyWith({
    double? interes,
    double? interesMoratorio,
    double? interesPunitorio,
    int? cuotas,
    int? monto,
    ArchivesModel? archivesModel,
    List<Map<String, dynamic>>? data,
    List<PrestamosModel>? prestamos,
    double? totalAPagar,
    double? totalInteres,
    DateTime? date,
    String? fecha,
    int? fechaMili,
    int? id,
  }) =>
      PrestamosState(
        interes: interes ?? this.interes,
        interesMoratorio: interesMoratorio ?? this.interesMoratorio,
        interesPunitorio: interesPunitorio ?? this.interesPunitorio,
        cuotas: cuotas ?? this.cuotas,
        monto: monto ?? this.monto,
        archivesModel: archivesModel ?? this.archivesModel,
        data: data ?? this.data,
        prestamos: prestamos ?? this.prestamos,
        totalAPagar: totalAPagar ?? this.totalAPagar,
        totalInteres: totalInteres ?? this.totalInteres,
        fecha: fecha ?? this.fecha,
        fechaMili: fechaMili ?? this.fechaMili,
        id: id ?? this.id,
      );
}
