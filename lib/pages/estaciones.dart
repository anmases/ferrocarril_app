import 'package:flutter/material.dart';

import '../connections/dao.dart';
import '../models/estacion.dart';

class EstacionesView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _EstacionesViewState();

}

class _EstacionesViewState extends State<EstacionesView>{
  final Dao<Estacion> dao = Dao<Estacion>(Estacion(0,"",""));
  int num = 0;

  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();



  @override
  void initState() {
    super.initState();
    dao.setAction("get", "estacion", {});
    dao.connect();
  }


  @override
  void dispose() {
    super.dispose();
    idController.dispose();
    nombreController.dispose();
    ciudadController.dispose();
    dao.disconnect();
  }

  void objectToForm(Estacion trenSeleccionado) {
    idController.text = trenSeleccionado.id.toString();
    nombreController.text = trenSeleccionado.nombre;
    ciudadController.text = trenSeleccionado.ciudad;
  }
  Estacion formToObject(){
    Estacion tren = Estacion(null, "", "");
    tren.id = int.tryParse(idController.text);
    tren.nombre = nombreController.text;
    tren.ciudad = ciudadController.text;
    return tren;
  }

  List<DataRow> createRows(List<Estacion> lista){
    List<DataRow> rows = [];
    for (Estacion item in lista){
      rows.add(
          DataRow(
              cells: [
                DataCell(Text(item.id.toString(),)),
                DataCell(Text(item.nombre)),
                DataCell(Text(item.ciudad)),
                DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent,), onPressed: (){
                  dao.setAction("delete", "estacion", item.toJson());
                  dao.clear();
                  dao.setAction("get", "estacion", {});
                },)),
                DataCell(IconButton(icon: const Icon(Icons.mode), onPressed: (){
                  objectToForm(item);
                },))
              ])
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    dao.getStream.first.then((value) =>
        setState(()=> num = value.length));
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
                        Text(" Estaciones: $num", style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
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
              controller: ciudadController,
              decoration: const InputDecoration(labelText: 'Ciudad'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingresa la ciudad';
                }
                return null;
              },
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    dao.setAction("post", "estacion", formToObject().toJson());
                    dao.clear();
                    dao.setAction("get", "estacion", {});
                    idController.clear();
                    nombreController.clear();
                    ciudadController.clear();
                  },
                  child: const Text('Enviar'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: IconButton(
                  onPressed: () {
                    idController.clear();
                    nombreController.clear();
                    ciudadController.clear();
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
              builder: (BuildContext context, AsyncSnapshot<List<Estacion>> snapshot) {
                List<Estacion> lista = snapshot.data ?? [];
                return DataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Nombre")),
                    DataColumn(label: Text("Ciudad")),
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