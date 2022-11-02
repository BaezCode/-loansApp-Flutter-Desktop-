part of 'prestamos_bloc.dart';

@immutable
abstract class PrestamosEvent {}

class SetUser extends PrestamosEvent {
  final ArchivesModel archivesModel;

  SetUser(this.archivesModel);
}

class SetPrestamo extends PrestamosEvent {
  final double interes;
  final int cuotas;
  final int monto;

  SetPrestamo(this.interes, this.cuotas, this.monto);
}

class SetList extends PrestamosEvent {
  final List<Map<String, dynamic>> data;

  SetList(
    this.data,
  );
}

class SetTotalInteres extends PrestamosEvent {
  final double totalInteres;

  SetTotalInteres(this.totalInteres);
}

class SetTotalApagar extends PrestamosEvent {
  final double totalAPagar;

  SetTotalApagar(this.totalAPagar);
}

class SetTotales extends PrestamosEvent {
  final double totalInteres;
  final double totalAPagar;

  SetTotales(this.totalInteres, this.totalAPagar);
}

class SetIntereses extends PrestamosEvent {
  final double interesMoratorio;
  final double interesPunitorio;

  SetIntereses(this.interesMoratorio, this.interesPunitorio);
}

class CargarPrestamos extends PrestamosEvent {
  final List<PrestamosModel> prestamos;

  CargarPrestamos(this.prestamos);
}

class ChargeAllData extends PrestamosEvent {
  final double interes;
  final int cuotas;
  final int monto;
  final List<Map<String, dynamic>> data;
  final ArchivesModel archivesModel;
  final double totalInteres;
  final double totalAPagar;
  final String fecha;
  final int fechaMili;
  final double interesMoratorio;
  final double interesPunitorio;
  final int id;

  ChargeAllData(
      this.interes,
      this.cuotas,
      this.monto,
      this.data,
      this.archivesModel,
      this.totalInteres,
      this.totalAPagar,
      this.fecha,
      this.fechaMili,
      this.interesMoratorio,
      this.interesPunitorio,
      this.id);
}

class ClearAll extends PrestamosEvent {}

class SetFechaMili extends PrestamosEvent {
  final int fechaMili;

  SetFechaMili(this.fechaMili);
}
