import 'dart:convert';

import 'estacion.dart';
import '../utils/serializable.dart';

class Empleado extends Serializable<Empleado>{
  int? id;
  String nombre;
  String puesto;
  String contratado;
  Estacion estacion;

  Empleado(this.id, this.nombre, this.puesto, this.contratado, this.estacion);

  @override
  Empleado fromJson(Map<String, dynamic> obj) {
    Estacion estacion = Estacion(0, "", "");
    Empleado empleado = Empleado(0, "", "", "", estacion);
    empleado.id = obj["id"];
    empleado.nombre = obj["nombre"];
    empleado.puesto = obj["puesto"];
    empleado.contratado = obj["contratado"];
    empleado.estacion = estacion.fromJson(obj["estacion"]);
    return empleado;
  }

  @override
  Map<String, dynamic> toJson() => {
   "id":id, "nombre":nombre, "puesto":puesto, "contratado":contratado, "estacion":estacion.toJson()
  };

  @override
  String toString() {
    return 'Empleado{id: $id, nombre: $nombre, puesto: $puesto, contratado: $contratado, estacion: $estacion}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Empleado &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre &&
          puesto == other.puesto &&
          contratado == other.contratado &&
          estacion == other.estacion;

  @override
  int get hashCode =>
      id.hashCode ^
      nombre.hashCode ^
      puesto.hashCode ^
      contratado.hashCode ^
      estacion.hashCode;
}