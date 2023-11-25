import 'package:ferrocarril_app/pages/empleados.dart';
import 'package:ferrocarril_app/pages/estaciones.dart';
import 'package:ferrocarril_app/pages/mantenimientos.dart';
import 'package:ferrocarril_app/pages/pasajeros.dart';
import 'package:ferrocarril_app/pages/trayectos.dart';
import 'package:ferrocarril_app/pages/trenes.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

//Definimos la función del navigationRail.
    bool isExpanded = false;
//y el índice del rail:
    int selectedIndex = 0;

    Widget setView(int index){
      switch(index){
        case 0:
          return TrenesView();
        case 1:
          return EstacionesView();
        case 2:
          return EmpleadosView();
        case 3:
          return MantenimientosView();
        case 4:
          return PasajerosView();
        case 5:
          return TrayectosView();
        default:
          return const Text("OPCION INCORRECTA");
      }
      
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(children: [
          NavigationRail(
            destinations: const [
            NavigationRailDestination(icon: Icon(Icons.train), label: Text("Trenes")),
            NavigationRailDestination(icon: Icon(Icons.home), label: Text("Estaciones")),
            NavigationRailDestination(icon: Icon(Icons.work), label: Text("Empleados")),
            NavigationRailDestination(icon: Icon(Icons.construction), label: Text("Mantenimientos")),
            NavigationRailDestination(icon: Icon(Icons.people), label: Text("Pasajeros")),
            NavigationRailDestination(icon: Icon(Icons.arrow_forward), label: Text("Trayectos")),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index){
              setState(() {
                selectedIndex = index;
              });
          },
          backgroundColor: Colors.cyanAccent[100],
          extended: isExpanded,),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:
                //Cuerpo de la vista:
                 Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        //Aquí se llama a la expasión del menú:
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      }, icon: const Icon(Icons.menu)),
                      const CircleAvatar(
                        backgroundImage: NetworkImage("https://picsum.photos/200"),
                        radius: 26.0,
                      )
                  ],),
                  //Dashboard:
                  const SizedBox(height: 20.0,),


                 setView(selectedIndex)
                ],)
                ,)
              ,)
      ],),
    );
  }
}
