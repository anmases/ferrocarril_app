
import 'package:ferrocarril_app/models/estacion.dart';
import 'package:ferrocarril_app/models/tren.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../connections/dao.dart';
import '../models/pasajero.dart';
import '../models/trayecto.dart';

class PasajerosView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PasajerosViewState();

}

class _PasajerosViewState extends State<PasajerosView>{
  List<Trayecto> trayectos = [];
  List<Trayecto> trayectosSeleccionados = [];
  final Dao<Pasajero> dao = Dao<Pasajero>(Pasajero(null,"","","", []));
  final Dao<Trayecto> daoTrayecto = Dao(Trayecto(null,Tren(null,"",0),Estacion(null,"",""),Estacion(null,"",""), "", ""));
  int num = 0;

  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController nacimientoController = TextEditingController();
  final MultiSelectController<Trayecto> trayectosController = MultiSelectController();


  @override
  void initState() {
    super.initState();
    dao.setAction("get", "pasajero", {});
    daoTrayecto.setAction("get", "trayecto", {});
    daoTrayecto.connect();
    dao.connect();
  }


  @override
  void dispose() {
    super.dispose();
    idController.dispose();
    nombreController.dispose();
    telefonoController.dispose();
    nacimientoController.dispose();
    trayectosController.dispose();
    dao.disconnect();
  }

  void objectToForm(Pasajero obj) {
    idController.text = obj.id.toString();
    nombreController.text = obj.nombre;
    telefonoController.text = obj.telefono;
    nacimientoController.text = obj.nacimiento;
    trayectosController.setSelectedOptions(optionsList(obj.trayectos));
  }
  Pasajero formToObject(){
    Pasajero pasajero = Pasajero(null,"","","", []);
    pasajero.id = int.tryParse(idController.text);
    pasajero.nombre = nombreController.text;
    pasajero.telefono = telefonoController.text;
    pasajero.nacimiento = nacimientoController.text;
    pasajero.trayectos = trayectosSeleccionados;
    return pasajero;
  }
  List<ValueItem<Trayecto>> optionsList(List<Trayecto> items){
    List<ValueItem<Trayecto>> options = [];
    for(Trayecto item in items){
      options.add(ValueItem(label: "id: ${item.id}", value: item));
    }
    return options;
  }
  List<DataRow> createRows(List<Pasajero> lista){
    List<DataRow> rows = [];
    for (Pasajero obj in lista){
      rows.add(
          DataRow(
              cells: [
                DataCell(Text(obj.id.toString(),)),
                DataCell(Text(obj.nombre)),
                DataCell(Text(obj.telefono)),
                DataCell(Text(obj.nacimiento)),
                DataCell(Text(obj.trayectos.length.toString())),
                DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent,), onPressed: (){
                  dao.setAction("delete", "pasajero", obj.toJson());
                  dao.clear();
                  dao.setAction("get", "pasajero", {});
                },)),
                DataCell(IconButton(icon: const Icon(Icons.mode), onPressed: (){
                  trayectosController.setOptions(optionsList(trayectos)); //volvemos a añadirle todas las opciones disponibles
                  objectToForm(obj);
                },))
              ])
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    dao.getStream.first.then((value) => setState(()=> num = value.length));
    daoTrayecto.getStream.first.then((value) => setState(()=>trayectos = value));
    return SingleChildScrollView(child:
    Column(children: [
      //panel superior:
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              child: Card(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.train, size: 26.0,),
                        const SizedBox(height: 15.0,),
                        Text("Pasajeros: $num", style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      ],),
                      const SizedBox(height: 20.0,),
                    ])
                ,)
          ),
        ],),
      const SizedBox(height: 20.0,),
      //Formulario:
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'id'),
              keyboardType: TextInputType.number,
              enabled: false, // Hace que el campo sea de solo lectura
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingresa el nombre';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: telefonoController,
              decoration: const InputDecoration(
                  labelText: 'Teléfono'
              ),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingresa el teléfono';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: nacimientoController,
              decoration: const InputDecoration(labelText: 'Nacimiento'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingresa la fecha de nacimiento';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: MultiSelectDropDown<Trayecto>(
              borderColor: Colors.transparent,
              controller: trayectosController,
              selectionType: SelectionType.multi,
                showClearIcon: true,
                hint: "Trayectos",
                onOptionSelected: (opciones){
                    trayectosSeleccionados = opciones.map((e) => e.value!).toList();
                },
                options: optionsList(
                    trayectos.where((element) => !trayectosSeleccionados.contains(element)).toList()
                )
            )
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    dao.setAction("post", "pasajero", formToObject().toJson());
                    dao.clear();
                    dao.setAction("get", "pasajero", {});
                    trayectosSeleccionados = [];
                    idController.clear();
                    nombreController.clear();
                    telefonoController.clear();
                    nacimientoController.clear();
                    trayectosController.clearAllSelection();
                  },
                  child: const Text('Enviar'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: IconButton(
                  onPressed: () {
                    trayectosSeleccionados = [];
                    idController.clear();
                    nombreController.clear();
                    telefonoController.clear();
                    nacimientoController.clear();
                    trayectosController.clearAllSelection();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
              ),
            ],
          ),
        ],),
      const SizedBox(height: 20.0,),
      //La tabla:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder(
              stream: dao.getStream,
              builder: (BuildContext context, AsyncSnapshot<List<Pasajero>> snapshot) {
                List<Pasajero> lista = snapshot.data ?? [];
                return DataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Nombre")),
                    DataColumn(label: Text("Teléfono")),
                    DataColumn(label: Text("Nacimiento")),
                    DataColumn(label: Text("Nº Trayectos")),
                    DataColumn(label: Text("Eliminar")),
                    DataColumn(label: Text("Modificar"))
                  ],
                  rows: createRows(lista),
                  headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                );
              }
          )
        ],
      )

    ],)
      ,);
  }
}