import 'package:flutter/material.dart';

import '../connections/dao.dart';
import '../models/empleado.dart';
import '../models/estacion.dart';


class EmpleadosView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _EmpleadosViewState();

}

class _EmpleadosViewState extends State<EmpleadosView>{
  Estacion? estacion;
  final Dao<Empleado> dao = Dao<Empleado>(Empleado(null,"","","", Estacion(null,"","")));
  final Dao<Estacion> daoEstacion = Dao<Estacion>(Estacion(null,"",""));
  int num = 0;
  List<Estacion> estaciones = [];





  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController puestoController = TextEditingController();
  final TextEditingController contratadoController = TextEditingController();




  @override
  void initState() {
    super.initState();
    dao.setAction("get", "empleado", {});
    daoEstacion.setAction("get", "estacion", {});
    dao.connect();
    daoEstacion.connect();
    daoEstacion.getStream.first.then((value) => estaciones = value);
  }


  @override
  void dispose() {
    super.dispose();
    idController.dispose();
    nombreController.dispose();
    puestoController.dispose();
    contratadoController.dispose();
    dao.disconnect();
    daoEstacion.disconnect();
  }

  void objectToForm(Empleado obj) {
    idController.text = obj.id.toString();
    nombreController.text = obj.nombre;
    puestoController.text = obj.puesto;
    contratadoController.text = obj.contratado;
  }
  Empleado formToObject(){
    Empleado empleado = Empleado(null,"","","",Estacion(null,"",""));
    empleado.id = int.tryParse(idController.text);
    empleado.nombre = nombreController.text;
    empleado.puesto = puestoController.text;
    empleado.contratado = contratadoController.text;
    if(estacion!=null) empleado.estacion = estacion!;
    return empleado;
  }

  List<DropdownMenuItem<Estacion>> createDropdownItems(List<Estacion> lista){
    List<DropdownMenuItem<Estacion>> items = [];
    for(var item in lista){
      items.add(DropdownMenuItem<Estacion>(
          value: item,
          child: Text("${item.nombre} (${item.ciudad})")
      ));
    }
    return items;
  }

  List<DataRow> createRows(List<Empleado> lista){
    List<DataRow> rows = [];
    for (Empleado obj in lista){
      rows.add(
          DataRow(
              cells: [
                DataCell(Text(obj.id.toString(),)),
                DataCell(Text(obj.nombre)),
                DataCell(Text(obj.puesto)),
                DataCell(Text(obj.contratado)),
                DataCell(Text(obj.estacion.nombre)),
                DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent,), onPressed: (){
                  dao.setAction("delete", "empleado", obj.toJson());
                  dao.clear();
                  dao.setAction("get", "empleado", {});
                },)),
                DataCell(IconButton(icon: const Icon(Icons.mode), onPressed: (){
                  setState(() =>estacion = obj.estacion);
                  objectToForm(obj);
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
                        Text("Empleados: $num", style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
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
          SizedBox(
            width: 60.0,
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
                  return 'Por favor ingresa el modelo';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: puestoController,
              decoration: const InputDecoration(labelText: 'Puesto'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingresa la capacidad';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: contratadoController,
              decoration: const InputDecoration(labelText: 'Contratado'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingresa la fecha de contrato';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: DropdownButton<Estacion>(
                value: estacion,
                hint: const Text("Estacion"),
                items: createDropdownItems(estaciones),
                onChanged: (Estacion? item){
                  if(item != null){
                    setState(() => estacion = item);
                  }
                }
            )
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    dao.setAction("post", "empleado", formToObject().toJson());
                    dao.clear();
                    dao.setAction("get", "empleado", {});
                    idController.clear();
                    nombreController.clear();
                    puestoController.clear();
                    contratadoController.clear();
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
                    puestoController.clear();
                    contratadoController.clear();
                    estacion = null;
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
              builder: (BuildContext context, AsyncSnapshot<List<Empleado>> snapshot) {
                List<Empleado> lista = snapshot.data ?? [];
                return DataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Nombre")),
                    DataColumn(label: Text("Puesto")),
                    DataColumn(label: Text("Contratado")),
                    DataColumn(label: Text("Estacion")),
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