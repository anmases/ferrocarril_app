import '../utils/serializable.dart';

class Estacion extends Serializable<Estacion>{
  int? id;
  String nombre;
  String ciudad;

  Estacion(this.id, this.nombre, this.ciudad);

  @override
  Estacion fromJson(Map<String, dynamic> obj) {
    Estacion estacion = Estacion(0, "", "");
    estacion.id = obj["id"];
    estacion.nombre = obj["nombre"];
    estacion.ciudad = obj["ciudad"];
    return estacion;
  }

  @override
  Map<String, dynamic> toJson() => {
    "id":id, "nombre":nombre, "ciudad":ciudad
  };

  @override
  String toString() {
    return 'Estacion{id: $id, nombre: $nombre, ciudad: $ciudad}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Estacion &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre &&
          ciudad == other.ciudad;

  @override
  int get hashCode => id.hashCode ^ nombre.hashCode ^ ciudad.hashCode;
}