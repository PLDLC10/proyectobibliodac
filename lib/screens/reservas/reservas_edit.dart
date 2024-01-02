import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:proyectobibliodac/widgets/appBar.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:proyectobibliodac/services/reservas.dart';

import 'package:provider/provider.dart';
import 'package:proyectobibliodac/providers/sesion.dart';

class reserva_edit extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _reservasEdit();
}

class _reservasEdit extends State<reserva_edit>{

  String titulo_ventana = "";

  String nombre_libro = "";
  String imagen = "";
  String autor = "";

  String username = "";

  String fecha_reserva = "";
  String url_default = "https://firebasestorage.googleapis.com/v0/b/db-bibliodac.appspot.com/o/portadas_libro%2Fdefault_libro.jpg?alt=media&token=c5310416-1628-4384-8a58-28642ed7703b";

  String anio = "";
  String mes = "";
  String dia = "";
  String fecha_hoy = "";

  List<String> list_anio = [];
  List<String> list_meses = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","setiembre","octubre","noviembre","diciembre"];
  List<String> list_dia = [];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Sesion>(context, listen: false);

    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    autor = arguments["autor"];
    nombre_libro = arguments["nombre_libro"];
    imagen = arguments["imagen"];
    username = arguments["username"];
    fecha_reserva = arguments["fecha_reserva"];

    if(userProvider.tipo == "ADMIN"){
      if(arguments["estado"] == "Reservado"){
        titulo_ventana = "ACTUALIZAR ESTADO A PRESTADO";
      }else if(arguments["estado"] == "Prestado"){
        titulo_ventana = "ACTUALIZAR ESTADO A DEVUELTO";
      }else if(arguments["estado"] == "Devuelto"){
        titulo_ventana = "RESERVA CONCLUIDA";
      }else{
        titulo_ventana = "LA RESERVA FUE CANCELADA";
      }
    }else{
      titulo_ventana = "ESTADO DE LA RESERVA";
    }

    if(anio == ""){
      tz.initializeTimeZones();
      DateTime hoy = DateTime.now();
      tz.Location origen = tz.getLocation('America/Lima');
      tz.TZDateTime origenDateTime = tz.TZDateTime.from(hoy, origen);
      fecha_hoy = DateFormat('dd MMMM yyyy', 'es').format(origenDateTime);

      //print(origenDateTime);
      print(fecha_hoy);

      dia = fecha_hoy.split(" ")[0];
      mes = fecha_hoy.split(" ")[1];
      anio = fecha_hoy.split(" ")[2];

      list_anio.add(anio);
      list_anio.add((int.parse(anio)+1).toString());

    }

    if(mes == "enero" || mes == "marzo" || mes == "mayo" || mes == "julio" || mes == "agosto" || mes == "octubre" || mes == "diciembre"){
      list_dia = [
        "01","02","03","04","05","06","07","08","09","10",
            "11","12","13","14","15","16","17","18","19","20",
            "21","22","23","24","25","26","27","28","29","30","31"
      ];
      if(list_dia.length < int.parse(dia)){
        dia = "01";
      }
    }else if(mes == "abril" || mes == "junio" || mes == "setiembre" || mes == "noviembre"){
      list_dia = [
        "01","02","03","04","05","06","07","08","09","10",
            "11","12","13","14","15","16","17","18","19","20",
            "21","22","23","24","25","26","27","28","29","30"
      ];
      if(list_dia.length < int.parse(dia)){
        dia = "01";
      }
    }else if(mes == "febrero" && int.parse(anio)%4==0){
      list_dia = [
        "01","02","03","04","05","06","07","08","09","10",
            "11","12","13","14","15","16","17","18","19","20",
            "21","22","23","24","25","26","27","28","29"
      ];
      if(list_dia.length < int.parse(dia)){
        dia = "01";
      }
    }else{
      list_dia = [
        "01","02","03","04","05","06","07","08","09","10",
            "11","12","13","14","15","16","17","18","19","20",
            "21","22","23","24","25","26","27","28"
      ];
      if(list_dia.length < int.parse(dia)){
        dia = "01";
      }
    }
    //print(list_dia);

    return Scaffold(
      appBar: AppBar_default(titulo: "EDITAR RESERVAS"),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Center(child: Text(titulo_ventana, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: Colors.blue,
                      width: 3
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(child: Text('LIBRO RESERVADO: ', style: TextStyle(color: Colors.deepPurple, fontSize: 25, fontWeight: FontWeight.bold),),),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
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
                                    Text("Título: "+nombre_libro+"\n", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text("Autor: "+autor, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: Colors.blue,
                      width: 3
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Center(child: Text('DATOS DE LA RESERVA:', style: TextStyle(color: Colors.deepPurple, fontSize: 25, fontWeight: FontWeight.bold),),),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text('Alumno: $username', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text('Fecha de la reserva: $fecha_reserva', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    arguments["estado"] != "Cancelado" ?
                    Row(
                      children: [
                        Text(
                          arguments['fecha_prestamo'] == "" ?
                              userProvider.tipo == "ALUMNO" ?
                                  "Fecha de prestamo aún no establecida" :
                          'Fecha de prestamo: $fecha_hoy' : 'Fecha de prestamo: '+arguments['fecha_prestamo']
                          , style: TextStyle(color:
                            arguments['estado'] == "Reservado" && userProvider.tipo == "ALUMNO"? Colors.green :
                        arguments['estado'] == "Prestado" || arguments['estado'] == "Devuelto"? Colors.green : Colors.red
                            , fontSize: 20, fontWeight: FontWeight.bold),),
                      ],
                    ):
                    Container(),
                    SizedBox(height: 10,),
                    arguments["estado"] != "Cancelado" ?
                        arguments["estado"] == "Reservado" && userProvider.tipo == "ALUMNO" ?
                            Row(
                              children: [
                                Text('Fecha de devolución aún no establecida ', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),)
                              ],
                            )
                            :


                    Row(
                      children: [
                        Text(
                          arguments['fecha_devolucion'] == "" ?
                          'Fecha de devolución: ' : 'Fecha de devolución: '+arguments['fecha_devolucion']
                          , style: TextStyle(color:
                        arguments['estado'] == "Prestado" || arguments['estado'] == "Devuelto"? Colors.green : Colors.red
                            , fontSize: 20, fontWeight: FontWeight.bold),),

                        arguments['fecha_devolucion'] == "" ?
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: anio,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            dropdownColor: Colors.grey[700],
                            onChanged: (String? newValue) {
                              setState(() {
                                anio = newValue!;
                              });
                            },
                            items:
                            list_anio.map<DropdownMenuItem<String>>((String value)
                            {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),
                              );
                            }).toList(),

                          ),
                        )
                            :
                        Container(),

                        arguments['fecha_devolucion'] == "" ?
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: mes,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            dropdownColor: Colors.grey[700],
                            onChanged: (String? newValue) {
                              setState(() {
                                mes = newValue!;
                              });
                            },
                            items:
                            list_meses.map<DropdownMenuItem<String>>((String value)
                            {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),
                              );
                            }).toList(),

                          ),
                        )
                            :
                        Container(),

                        arguments['fecha_devolucion'] == "" ?
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dia,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            dropdownColor: Colors.grey[700],
                            onChanged: (String? newValue) {
                              setState(() {
                                dia = newValue!;
                              });
                            },
                            items:
                            list_dia.map<DropdownMenuItem<String>>((String value)
                            {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),
                              );
                            }).toList(),

                          ),
                        ):
                        Container(),

                      ],
                    ):
                    Container(),
                    SizedBox(height: 10,),
                    userProvider.tipo == "ADMIN" ?
                    arguments['estado'] == "Prestado" ?
                    MaterialButton(
                      padding: EdgeInsets.only(right: 25, left: 25, top: 5, bottom: 5),
                      child: Text("Actualizar Fecha de Devolución", style: TextStyle(color: Colors.white, fontSize: 25),),
                      color: Colors.indigo,
                      onPressed: () async{
                        Navigator.pushNamed(context, '/update_fecha_devolucion', arguments: {
                          "id": arguments["id"],
                          "id_libro": arguments["id_libro"],
                          "username": arguments["username"],
                          "fecha_reserva": arguments["fecha_reserva"],
                          "fecha_prestamo": arguments["fecha_prestamo"],
                          "fecha_devolucion": arguments["fecha_devolucion"],
                          "estado": arguments["estado"],
                          "nombre_libro": arguments["nombre_libro"],
                          "autor": arguments["autor"],
                          "imagen": arguments["imagen"]
                        });
                      },
                    ):
                    Container()
                        :
                    Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),

              userProvider.tipo == "ADMIN" ?
              arguments["estado"] == "Cancelado" || arguments["estado"] == "Devuelto"?
                  Container()
              : Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        color: Colors.blue,
                        width: 3
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Center(child: Text('CAMBIO DE ESTADO:', style: TextStyle(color: Colors.deepPurple, fontSize: 25, fontWeight: FontWeight.bold),),),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: arguments["estado"] == "Reservado" ? Colors.blue
                                    : arguments["estado"] == "Prestado" ? Colors.green
                                    : arguments["estado"] == "Devuelto" ? Colors.orange
                                    : arguments["estado"] == "Cancelado" ? Colors.red
                                    : Colors.black,
                              ),
                              child: Center(
                                child: Text('ESTADO ACTUAL: \n'+arguments['estado'], style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),

                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 40,
                              child: Text("asd"),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/flecha_derecha.png'),
                                      fit: BoxFit.contain
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: arguments["estado"] == "Reservado" ? Colors.green
                                    : arguments["estado"] == "Prestado" ? Colors.orange
                                    : Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  arguments["estado"] == "Reservado" ? 'ESTADO NUEVO: \nPrestado'
                                      : arguments["estado"] == "Prestado" ? 'ESTADO NUEVO: \nDevuelto'
                                      : "Error"
                                  , style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),

                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
              )
              : Container(),
              SizedBox(height: 20),

              userProvider.tipo == "ADMIN" ?
              arguments["estado"] == "Reservado" || arguments["estado"] == "Prestado"?
              MaterialButton(
                padding: EdgeInsets.only(right: 25, left: 25, top: 5, bottom: 5),
                child: Text("Actualizar Estado", style: TextStyle(color: Colors.white, fontSize: 25),),
                color: Colors.indigo,
                onPressed: () async{
                  if(arguments['estado'] == "Reservado"){
                    String fecha_devolucion = dia+" "+mes+" "+anio;
                    List data = [fecha_hoy, fecha_devolucion];

                    await update_Prestado(arguments['id'], data).then((_) {
                      Navigator.pop(context);
                    });
                  }else if(arguments['estado'] == "Prestado"){
                    print("ola papaus");
                    await update_Devuelto(arguments["id"], arguments["id_libro"], fecha_hoy).then((_){
                      Navigator.pop(context);
                    });
                  }
                },
              ):
              Container()
                  :
              Container()
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () async{
          if(arguments['estado'] == "Reservado"){
            bool result = await showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text("¿Está seguro de querer cancelar la reserva?"),
                  actions: [
                    TextButton(onPressed: (){
                      return Navigator.pop(context, false);
                    }, child: Text("NO")
                    ),
                    TextButton(onPressed: (){
                      return Navigator.pop(context, true);
                    }, child: Text("SI")
                    )
                  ],
                );
              },
            );
            if(result){
              await update_Cancelado(arguments['id'], arguments['id_libro']).then((_){
                Navigator.pop(context);
              });
              print("se va a cancelar");
            }
          }else{
            print("imposible cancelar");
          }
        },
      ),
    );
  }
}