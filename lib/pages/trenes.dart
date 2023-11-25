import 'package:flutter/material.dart';

import '../connections/dao.dart';
import '../models/tren.dart';

class TrenesView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _TrenesViewState();

}

class _TrenesViewState extends State<TrenesView>{
  final Dao<Tren> dao = Dao<Tren>(Tren(0,"",0));
  int num = 0;

  final TextEditingController idController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController capacidadController = TextEditingController();



  @override
  void initState() {
    super.initState();
    dao.setAction("get", "tren", {});
    dao.connect();
  }


  @override
  void dispose() {
    super.dispose();
    idController.dispose();
    modeloController.dispose();
    capacidadController.dispose();
    dao.disconnect();
  }

  void objectToForm(Tren trenSeleccionado) {
    idController.text = trenSeleccionado.id.toString();
    modeloController.text = trenSeleccionado.modelo;
    capacidadController.text = trenSeleccionado.capacidad.toString();
  }
  Tren formToObject(){
    Tren tren = Tren(null, "", 0);
    tren.id = int.tryParse(idController.text);
    tren.modelo = modeloController.text;
    tren.capacidad = int.parse(capacidadController.text);
    return tren;
  }

  List<DataRow> createRows(List<Tren> lista){
    List<DataRow> rows = [];
    for (Tren tren in lista){
      rows.add(
          DataRow(
              cells: [
            DataCell(Text(tren.id.toString(),)),
            DataCell(Text(tren.modelo)),
            DataCell(Text(tren.capacidad.toString())),
            DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent,), onPressed: (){
              dao.setAction("delete", "tren", tren.toJson());
              dao.clear();
              dao.setAction("get", "tren", {});
            },)),
            DataCell(IconButton(icon: const Icon(Icons.mode), onPressed: (){
              objectToForm(tren);
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
                          Text(" Trenes: $num", style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
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
                controller: modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor ingresa el modelo';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: capacidadController,
                decoration: const InputDecoration(labelText: 'Capacidad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null) {
                    return 'Por favor ingresa la capacidad';
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
                      dao.setAction("post", "tren", formToObject().toJson());
                      dao.clear();
                      dao.setAction("get", "tren", {});
                      idController.clear();
                      modeloController.clear();
                      capacidadController.clear();
                    },
                    child: const Text('Enviar'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: IconButton(
                    onPressed: () {
                      idController.clear();
                      modeloController.clear();
                      capacidadController.clear();
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
            builder: (BuildContext context, AsyncSnapshot<List<Tren>> snapshot) {
              List<Tren> lista = snapshot.data ?? [];
              return DataTable(
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Modelo")),
                  DataColumn(label: Text("Capacidad")),
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