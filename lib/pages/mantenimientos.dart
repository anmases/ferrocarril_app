import 'package:ferrocarril_app/models/mantenimiento.dart';
import 'package:flutter/material.dart';

import '../connections/dao.dart';
import '../models/empleado.dart';
import '../models/estacion.dart';
import '../models/tren.dart';

class MantenimientosView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MantenimientosViewState();

}

class _MantenimientosViewState extends State<MantenimientosView>{
  Tren? tren;
  Empleado? empleado;
  List<Tren> trenes = [];
  List<Empleado> empleados = [];
  final Dao<Tren> daoTren = Dao<Tren>(Tren(null,"",0));
  final Dao<Empleado> daoEmpleado = Dao(Empleado(null,"","","", Estacion(null,"","")));
  final Dao<Mantenimiento> dao = Dao<Mantenimiento>(Mantenimiento(null,"","","", Tren(null,"",0), Empleado(null, "", "", "", Estacion(null, "", ""))));
  int num = 0;

  final TextEditingController idController = TextEditingController();
  final TextEditingController inicioController = TextEditingController();
  final TextEditingController finController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();



  @override
  void initState() {
    super.initState();
    daoTren.setAction("get", "tren", {});
    daoEmpleado.setAction("get", "empleado", {});
    dao.setAction("get", "mantenimiento", {});
    daoTren.connect();
    daoEmpleado.connect();
    dao.connect();
    daoTren.getStream.first.then((value) => trenes = value);
    daoEmpleado.getStream.first.then((value) => empleados = value);
  }


  @override
  void dispose() {
    super.dispose();
    idController.dispose();
    inicioController.dispose();
    finController.dispose();
    descripcionController.dispose();
    dao.disconnect();
    daoTren.disconnect();
    daoEmpleado.disconnect();
  }

  void objectToForm(Mantenimiento obj) {
    idController.text = obj.id.toString();
    inicioController.text = obj.inicio;
    finController.text = obj.fin;
    descripcionController.text = obj.descripcion;
  }
  Mantenimiento formToObject(){
    Mantenimiento mantenimiento = Mantenimiento(null,"","","",Tren(null,"",0), Empleado(null,"","","",Estacion(null,"","")));
    mantenimiento.id = int.tryParse(idController.text);
    mantenimiento.inicio = inicioController.text;
    mantenimiento.fin = finController.text;
    mantenimiento.descripcion = descripcionController.text;
    if(tren != null) mantenimiento.tren = tren!;
    if(empleado != null) mantenimiento.empleado = empleado!;
    return mantenimiento;
  }

  List<DropdownMenuItem<Tren>> createDropdownTrains(List<Tren> lista){
    List<DropdownMenuItem<Tren>> items = [];
    for(var item in lista){
      items.add(DropdownMenuItem<Tren>(
          value: item,
          child: Text("${item.id}-${item.modelo}")
      ));
    }
    return items;
  }
  List<DropdownMenuItem<Empleado>> createDropdownEmployees(List<Empleado> lista){
    List<DropdownMenuItem<Empleado>> items = [];
    for(var item in lista){
      items.add(DropdownMenuItem<Empleado>(
          value: item,
          child: Text("${item.nombre}")
      ));
    }
    return items;
  }

  List<DataRow> createRows(List<Mantenimiento> lista){
    List<DataRow> rows = [];
    for (Mantenimiento obj in lista){
      rows.add(
          DataRow(
              cells: [
                DataCell(Text(obj.id.toString(),)),
                DataCell(Text(obj.inicio)),
                DataCell(Text(obj.fin)),
                DataCell(Text(obj.descripcion)),
                DataCell(Text(obj.tren.id.toString())),
                DataCell(Text(obj.empleado.nombre)),
                DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent,), onPressed: (){
                  dao.setAction("delete", "mantenimiento", obj.toJson());
                  dao.clear();
                  dao.setAction("get", "mantenimiento", {});
                },)),
                DataCell(IconButton(icon: const Icon(Icons.mode), onPressed: (){
                  setState(() {
                    tren = obj.tren;
                    empleado = obj.empleado;
                  });
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
                        Text("Mantenimientos: $num", style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
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
              controller: inicioController,
              decoration: const InputDecoration(labelText: 'Inicio'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingresa la fecha de Inicio';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: finController,
              decoration: const InputDecoration(labelText: 'Fin'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingresa la fecha de fin';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripcion'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingresa la Descripcion';
                }
                return null;
              },
            ),
          ),
          Expanded(
              child: DropdownButton<Tren>(
                  value: tren,
                  hint: const Text("Tren"),
                  items: createDropdownTrains(trenes),
                  onChanged: (Tren? item){
                    if(item != null){
                      setState(() => tren = item);
                    }
                  }
              )
          ),
          Expanded(
              child: DropdownButton<Empleado>(
                  value: empleado,
                  hint: const Text("Empleado"),
                  items: createDropdownEmployees(empleados),
                  onChanged: (Empleado? item){
                    if(item != null){
                      setState(() => empleado = item);
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
                    dao.setAction("post", "mantenimiento", formToObject().toJson());
                    dao.clear();
                    dao.setAction("get", "mantenimiento", {});
                    idController.clear();
                    inicioController.clear();
                    finController.clear();
                    descripcionController.clear();
                  },
                  child: const Text('Enviar'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: IconButton(
                  onPressed: () {
                    idController.clear();
                    inicioController.clear();
                    finController.clear();
                    descripcionController.clear();
                    tren = null;
                    empleado = null;
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
              builder: (BuildContext context, AsyncSnapshot<List<Mantenimiento>> snapshot) {
                List<Mantenimiento> lista = snapshot.data ?? [];
                return DataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Inicio")),
                    DataColumn(label: Text("Fin")),
                    DataColumn(label: Text("Descripcion")),
                    DataColumn(label: Text("Tren")),
                    DataColumn(label: Text("Empleado")),
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