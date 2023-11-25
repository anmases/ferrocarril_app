

import '../utils/serializable.dart';
import 'estacion.dart';
import 'tren.dart';

class Trayecto extends Serializable<Trayecto>{
  int? id;
  Tren tren;
  Estacion estacion1;
  Estacion estacion2;
  String fecha;
  String hora;

  Trayecto(this.id, this.tren, this.estacion1, this.estacion2, this.fecha, this.hora);

  @override
  Trayecto fromJson(Map<String, dynamic> obj) {
    Tren tren = Tren(0, "", 0);
    Estacion estacion = Estacion(0, "", "");
    Trayecto trayecto = Trayecto(0, tren, estacion, estacion, "", "");
    trayecto.id = obj["id"];
    trayecto.tren = tren.fromJson(obj["tren"]);
    trayecto.estacion1 = estacion.fromJson(obj["estacion1"]);
    trayecto.estacion2 = estacion.fromJson(obj["estacion2"]);
    trayecto.fecha = obj["fecha"];
    trayecto.hora = obj["hora"];
    return trayecto;
  }

  @override
  Map<String, dynamic> toJson() => {
    "id":id, "tren":tren.toJson(), "estacion1":estacion1.toJson(), "estacion2":estacion2.toJson(), "fecha":fecha, "hora":hora
  };

  @override
  String toString() {
    return 'Trayecto{id: $id, tren: $tren, estacion1: $estacion1, estacion2: $estacion2, fecha: $fecha, hora: $hora}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Trayecto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          tren == other.tren &&
          estacion1 == other.estacion1 &&
          estacion2 == other.estacion2 &&
          fecha == other.fecha &&
          hora == other.hora;

  @override
  int get hashCode =>
      id.hashCode ^
      tren.hashCode ^
      estacion1.hashCode ^
      estacion2.hashCode ^
      fecha.hashCode ^
      hora.hashCode;
}