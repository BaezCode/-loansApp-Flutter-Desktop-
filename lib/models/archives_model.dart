


// To parse this JSON data, do
//
//     final archivesModel = archivesModelFromJson(jsonString);

import 'dart:convert';

ArchivesModel archivesModelFromJson(String str) => ArchivesModel.fromJson(json.decode(str));

String archivesModelToJson(ArchivesModel data) => json.encode(data.toJson());

class ArchivesModel {
    ArchivesModel({
        this.id,
        required this.cedula,
         this.cuotas,
         this.interes,
         this.monto,
        required this.nombre,
        required this.telefono,
        required this.trabaja,
        this.obs,
        this.idCliente,
        this.fecha,
        required this.direccion,
        required this.referencia,
      
    });

    int? id;
    int? cedula;
    int? cuotas;
    int? interes;
    int? monto;
    String nombre;
    String telefono;
    String trabaja;
    String? obs;
    String? idCliente;
    String? fecha;
    String? direccion;
    String? referencia;
   

    factory ArchivesModel.fromJson(Map<String, dynamic> json) => ArchivesModel(
        id: json["id"],
        cedula: json["cedula"],
        cuotas: json["cuotas"],
        interes: json["interes"],
        monto: json["monto"],
        nombre: json["nombre"],
        telefono: json["telefono"],
        trabaja: json["trabaja"],
        obs: json["obs"],
        idCliente: json["idCliente"],
        fecha: json["fecha"],
        direccion: json["direccion"],
        referencia: json["referencia"],
       
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cedula": cedula,
        "cuotas": cuotas,
        "interes": interes,
        "monto": monto,
        "nombre": nombre,
        "telefono": telefono,
        "trabaja": trabaja,
        "obs": obs,
        "idCliente": idCliente,
        "fecha": fecha,
        "direccion": direccion,
        "referencia": referencia,
  
    };
}
