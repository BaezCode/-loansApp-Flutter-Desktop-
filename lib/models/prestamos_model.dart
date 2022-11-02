// To parse this JSON data, do
//
//     final prestamosModel = prestamosModelFromJson(jsonString);

import 'dart:convert';

PrestamosModel prestamosModelFromJson(String str) =>
    PrestamosModel.fromJson(json.decode(str));

String prestamosModelToJson(PrestamosModel data) => json.encode(data.toJson());

class PrestamosModel {
  PrestamosModel({
    this.id,
    required this.idCliente,
    required this.monto,
    required this.interes,
    required this.interesMoratorio,
    required this.interesPunitorio,
    required this.cuotas,
    required this.nombre,
    required this.data,
    this.obs,
    required this.fecha,
    this.fechaPago,
    required this.fechaMili,
    this.totalAPagar,
    this.totalInteres,
  });

  int? id;
  String idCliente;
  int monto;
  double interes;
  double interesMoratorio;
  double interesPunitorio;
  int cuotas;
  String nombre;
  String data;
  String? obs;
  String fecha;
  String? fechaPago;
  int fechaMili;
  double? totalAPagar;
  double? totalInteres;

  factory PrestamosModel.fromJson(Map<String, dynamic> json) => PrestamosModel(
        id: json["id"],
        idCliente: json["idCliente"],
        monto: json["monto"],
        interes: json["interes"],
        interesMoratorio: json["interesMoratorio"],
        interesPunitorio: json["interesPunitorio"],
        cuotas: json["cuotas"],
        nombre: json["nombre"],
        data: json["data"],
        obs: json["obs"],
        fecha: json["fecha"],
        fechaPago: json["fechaPago"],
        fechaMili: json["fechaMili"],
        totalAPagar: json["totalAPagar"],
        totalInteres: json["totalInteres"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idCliente": idCliente,
        "monto": monto,
        "nombre": nombre,
        "interes": interes,
        "interesMoratorio": interesMoratorio,
        "interesPunitorio": interesPunitorio,
        "cuotas": cuotas,
        "data": data,
        "obs": obs,
        "fecha": fecha,
        "fechaPago": fechaPago,
        "fechaMili": fechaMili,
        "totalAPagar": totalAPagar,
        "totalInteres": totalInteres,
      };
}
