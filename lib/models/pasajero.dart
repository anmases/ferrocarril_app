

import '../utils/serializable.dart';
import 'estacion.dart';
import 'trayecto.dart';
import 'tren.dart';

class Pasajero extends Serializable<Pasajero>{
  int? id;
  String nombre;
  String telefono;
  String nacimiento;
  List<Trayecto> trayectos;

  Pasajero(
      this.id, this.nombre, this.telefono, this.nacimiento, this.trayectos);

  @override
  Pasajero fromJson(Map<String, dynamic> obj) {
    Trayecto trayecto = Trayecto(0, Tren(0,"",0), Estacion(0,"",""), Estacion(0,"",""), "", "");
    Pasajero pasajero = Pasajero(0, "", "", "", []);
    pasajero.id = obj["id"];
    pasajero.nombre = obj["nombre"];
    pasajero.telefono = obj["telefono"];
    pasajero.nacimiento = obj["nacimiento"];
    pasajero.trayectos = (obj["trayectos"] as List<dynamic>).map((item) => trayecto.fromJson(item)).toList();
    return pasajero;
  }

  @override
  Map<String, dynamic> toJson() =>{
    "id":id, "nombre":nombre, "telefono":telefono, "nacimiento":nacimiento, "trayectos":trayectos.map((item) => item.toJson()).toList()
  };

  @override
  String toString() {
    return 'Pasajero{id: $id, nombre: $nombre, telefono: $telefono, nacimiento: $nacimiento, trayectos: $trayectos}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pasajero &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre &&
          telefono == other.telefono &&
          nacimiento == other.nacimiento &&
          trayectos == other.trayectos;

  @override
  int get hashCode =>
      id.hashCode ^
      nombre.hashCode ^
      telefono.hashCode ^
      nacimiento.hashCode ^
      trayectos.hashCode;
}