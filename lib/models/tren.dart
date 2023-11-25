

import '../utils/serializable.dart';

class Tren extends Serializable<Tren>{
  int? id;
  String modelo;
  int capacidad;

  Tren(this.id, this.modelo, this.capacidad);

  @override
  Tren fromJson(Map<String, dynamic> obj) {
    Tren tren = Tren(null, "", 0);
    tren.id = obj["id"];
    tren.modelo = obj["modelo"];
    tren.capacidad = obj["capacidad"];
    return tren;
  }

  @override
  Map<String, dynamic> toJson() => {
    "id": id, "modelo":modelo, "capacidad": capacidad
  };

  @override
  String toString() {
    return 'Tren{id: $id, modelo: $modelo, capacidad: $capacidad}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tren &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          modelo == other.modelo &&
          capacidad == other.capacidad;

  @override
  int get hashCode => id.hashCode ^ modelo.hashCode ^ capacidad.hashCode;
}