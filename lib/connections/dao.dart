import 'dart:convert';


import 'package:rxdart/subjects.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/tren.dart';
import '../utils/serializable.dart';


class Dao<T extends Serializable<T>>{
  final T entity;
  final _channel = WebSocketChannel.connect(Uri.parse("ws://localhost:3500"));
  final List<T> items = [];
  final streamController = BehaviorSubject<List<T>>();

  Dao(this.entity);

  ///Getter del stream principal:
  Stream<List<T>> get getStream => streamController.stream;

  ///Método para enviar peticiones al servidor.
  void setAction(String action, String type, Map<String, dynamic> data){
    Map<String, dynamic> object = {"action":action, "type": type, "data":data};
    _channel.sink.add(jsonEncode(object));
  }
  ///Método que establece conexión con el servidor.
  void connect() {
    _channel.stream.listen((data) {
      data = data.trim(); //elimina espacios blancos y caracteres al inicio y final.
      onDataReceived(data);
    },
        onDone: ()=>print("El servidor ha cerrado la conexión"),
        onError: (error)=>print("Error $error")
    );
  }

  void onDataReceived(String data){
    print(data);
    final Map<String, dynamic> json = jsonDecode(data);
    items.add(entity.fromJson(json));
    streamController.sink.add(items);
  }

  ///Método que limpia el caché del Stream.
  void clear(){
    items.clear();
    streamController.sink.add(items);
  }
  ///Método que cierra las conexiones básicas con el servidor y los distintos Streams.
  void disconnect() {
    print("Has cerrado la conexión");
    streamController.sink.close();
    _channel.sink.close();
  }

}

void main(){
  Dao dao = Dao<Tren>(Tren(0,"",0));
  dao.setAction("get", "mantenimiento", {});
  dao.connect();
  dao.streamController.listen((value) => {
    for(var item in value){
      print(item.toString())
    }
  });
}