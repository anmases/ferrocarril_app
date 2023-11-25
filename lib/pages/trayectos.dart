
import 'package:ferrocarril_app/models/estacion.dart';
import 'package:ferrocarril_app/models/tren.dart';
import 'package:flutter/material.dart';

import '../connections/dao.dart';
import '../models/trayecto.dart';

class TrayectosView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _TrayectosViewState();

}

class _TrayectosViewState extends State<TrayectosView>{
  Tren? tren;
  Estacion? estacion1;
  Estacion? estacion2;
  List<Estacion> estaciones = [];
  List<Tren> trenes = [];
  final Dao<Tren> daoTren = Dao<Tren>(Tren(null,"",0));
  final Dao<Estacion> daoEstacion = Dao<Estacion>(Estacion(null,"",""));
  final Dao<Trayecto> dao = Dao<Trayecto>(Trayecto(null,Tren(null,"",0), Estacion(null,"",""), Estacion(null,"",""), "",""));
  int num = 0;

  final TextEditingController idController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController horaController = TextEditingController();


  @override
  void initState() {
    super.initState();
    dao.setAction("get", "trayecto", {});
    daoTren.setAction("get", "tren", {});
    daoEstacion.setAction("get", "estacion", {});
    daoTren.connect();
    daoEstacion.connect();
    dao.connect();
    daoTren.getStream.first.then((value) => trenes = value);
    daoEstacion.getStream.first.then((value) => estaciones = value);
  }


  @override
  void dispose() {
    super.dispose();
    idController.dispose();
    fechaController.dispose();
    horaController.dispose();
    dao.disconnect();
    daoTren.disconnect();
    daoEstacion.disconnect();
  }

  void objectToForm(Trayecto obj) {
    idController.text = obj.id.toString();
    fechaController.text = obj.fecha;
    horaController.text = obj.hora;
  }
  Trayecto formToObject(){
    Trayecto trayecto = Trayecto(null,Tren(null,"",0),Estacion(null,"",""),Estacion(null,"",""), "","");
    trayecto.id = int.tryParse(idController.text);
    trayecto.fecha = fechaController.text;
    trayecto.hora = horaController.text;
    if(tren != null) trayecto.tren = tren!;
    if(estacion1 != null) trayecto.estacion1 = estacion1!;
    if(estacion2 != null) trayecto.estacion2 = estacion2!;
    return trayecto;
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

  List<DropdownMenuItem<Estacion>> createDropdownStation(List<Estacion> lista){
    List<DropdownMenuItem<Estacion>> items = [];
    for(var item in lista){
      items.add(DropdownMenuItem<Estacion>(
          value: item,
          child: Text("${item.nombre} (${item.ciudad})")
      ));
    }
    return items;
  }

  List<DataRow> createRows(List<Trayecto> lista){
    List<DataRow> rows = [];
    for (Trayecto obj in lista){
      rows.add(
          DataRow(
              cells: [
                DataCell(Text(obj.id.toString(),)),
                DataCell(Text(obj.tren.modelo)),
                DataCell(Text(obj.estacion1.nombre)),
                DataCell(Text(obj.estacion2.nombre)),
                DataCell(Text(obj.fecha)),
                DataCell(Text(obj.hora)),
                DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent,), onPressed: (){
                  dao.setAction("delete", "trayecto", obj.toJson());
                  dao.clear();
                  dao.setAction("get", "trayecto", {});
                },)),
                DataCell(IconButton(icon: const Icon(Icons.mode), onPressed: (){
                  setState(() {
                    tren = obj.tren;
                    estacion1 = obj.estacion1;
                    estacion2 = obj.estacion2;
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
                        Text("Trayectos: $num", style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
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
              child: DropdownButton<Estacion>(
                  value: estacion1,
                  hint: const Text("Estación salida"),
                  items: createDropdownStation(estaciones),
                  onChanged: (Estacion? item){
                    if(item != null){
                      setState(() => estacion1 = item);
                    }
                  }
              )
          ),
          Expanded(
              child: DropdownButton<Estacion>(
                  value: estacion2,
                  hint: const Text("Estación llegada"),
                  items: createDropdownStation(estaciones),
                  onChanged: (Estacion? item){
                    if(item != null){
                      setState(() => estacion2 = item);
                    }
                  }
              )
          ),
          SizedBox(
            width: 150.0,
            child: TextFormField(
              enabled: true,
              controller: fechaController,
              decoration: const InputDecoration(labelText: 'Fecha'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingresa La fecha';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            width: 100.0,
            child: TextFormField(
              enabled: true,
              controller: horaController,
              decoration: const InputDecoration(labelText: 'Hora'),
              validator: (value) {
                if (value == null) {
                  return 'Por favor ingresa La hora';
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
                    dao.setAction("post", "trayecto", formToObject().toJson());
                    dao.clear();
                    dao.setAction("get", "trayecto", {});
                    idController.clear();
                    fechaController.clear();
                    horaController.clear();
                    tren = null;
                    estacion1 = null;
                    estacion2 = null;
                  },
                  child: const Text('Enviar'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: IconButton(
                  onPressed: () {
                    idController.clear();
                    fechaController.clear();
                    horaController.clear();
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
              builder: (BuildContext context, AsyncSnapshot<List<Trayecto>> snapshot) {
                List<Trayecto> lista = snapshot.data ?? [];
                return DataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Tren")),
                    DataColumn(label: Text("Salida")),
                    DataColumn(label: Text("Llegada")),
                    DataColumn(label: Text("Fecha")),
                    DataColumn(label: Text("Hora")),
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