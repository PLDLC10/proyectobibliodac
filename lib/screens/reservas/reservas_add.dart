import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:proyectobibliodac/services/reservas.dart';

import 'package:proyectobibliodac/widgets/appBar.dart';
import 'package:proyectobibliodac/widgets/input_decoration.dart';

import 'package:proyectobibliodac/providers/sesion.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class reserva_add extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _reservaAdd();
}

class _reservaAdd extends State<reserva_add>{

  TextEditingController fecha_reserva = TextEditingController(text: "");
  String id_libro = "";
  String titulo = "";
  String autor = "";
  String stock = "";
  String imagen = "";

  String url_default = "https://firebasestorage.googleapis.com/v0/b/db-bibliodac.appspot.com/o/portadas_libro%2Fdefault_libro.jpg?alt=media&token=c5310416-1628-4384-8a58-28642ed7703b";
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Sesion>(context, listen: false);

    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    id_libro = arguments["id_libro"];
    titulo = arguments["titulo"];
    autor = arguments["autor"];
    stock = arguments["stock"];
    imagen = arguments["imagen"];

    tz.initializeTimeZones();
    DateTime hoy = DateTime.now();
    tz.Location origen = tz.getLocation('America/Lima');
    tz.TZDateTime origenDateTime = tz.TZDateTime.from(hoy, origen);
    String formattedDate = DateFormat('dd MMMM yyyy', 'es').format(hoy);
    fecha_reserva.text = formattedDate;

    return Scaffold(
        appBar: AppBar_default(titulo: "RESERVAR LIBRO",),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20, bottom: 5, top: 5),
                  child: ListTile(
                    title: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                  imagen == "" ?
                                  NetworkImage(url_default)
                                      :
                                  NetworkImage(imagen),
                                  fit: BoxFit.fill
                              ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                            ),
                          ),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Título: "+titulo+"\n", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                                Text("Autor: "+autor, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900),),
                              ],
                            ),
                          ),
                          int.parse(stock) <= 0 ?
                          Container(
                            width: 100,
                            child:
                            Center(child: Text("Agotado", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),),),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                            ),
                          )
                              :
                          Container(
                            width: 100,
                            child:
                            Center(child: Text("Disponible", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),),),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('FECHA RESERVA: ', style: TextStyle(color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold),),
                    Text(formattedDate, style: TextStyle(color: Colors.indigo, fontSize: 30, fontWeight: FontWeight.bold),),
                  ],
                ),

                SizedBox(
                  height: 50,
                ),
                ElevatedButton(onPressed: () async{

                  List data = [id_libro, userProvider.id, fecha_reserva.text];
                  print(data);
                  await addReserva(data).then((_) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/reservas_home');
                  });
                }, child: Text('Reservar'))
              ],
            ),
          ),
        )
    );
  }

}
