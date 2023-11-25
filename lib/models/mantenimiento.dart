import 'empleado.dart';
import 'estacion.dart';
import 'tren.dart';
import '../utils/serializable.dart';

class Mantenimiento extends Serializable<Mantenimiento>{
  int? id;
  String inicio;
  String fin;
  String descripcion;
  Tren tren;
  Empleado empleado;

  Mantenimiento(this.id, this.inicio, this.fin, this.descripcion, this.tren, this.empleado);

  @override
  Mantenimiento fromJson(Map<String, dynamic> obj) {
    Tren tren = Tren(0,"",0);
    Empleado empleado = Empleado(0,"","","",Estacion(0,"",""));
    Mantenimiento mantenimiento = Mantenimiento(0,"","","",tren,empleado);
    mantenimiento.id = obj["id"];
    mantenimiento.inicio = obj["inicio"];
    mantenimiento.fin = obj["fin"];
    mantenimiento.descripcion = obj["descripcion"];
    mantenimiento.tren = tren.fromJson(obj["tren"]);
    mantenimiento.empleado = empleado.fromJson(obj["empleado"]);
    return mantenimiento;
  }

  @override
  Map<String, dynamic> toJson() =>{
    "id":id, "inicio":inicio, "fin":fin, "descripcion":descripcion, "tren":tren.toJson(), "empleado":empleado.toJson()
  };

  @override
  String toString() {
    return 'Mantenimiento{id: $id, inicio: $inicio, fin: $fin, descripcion: $descripcion, tren: $tren, empleado: $empleado}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Mantenimiento &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          inicio == other.inicio &&
          fin == other.fin &&
          descripcion == other.descripcion &&
          tren == other.tren &&
          empleado == other.empleado;

  @override
  int get hashCode =>
      id.hashCode ^
      inicio.hashCode ^
      fin.hashCode ^
      descripcion.hashCode ^
      tren.hashCode ^
      empleado.hashCode;
}