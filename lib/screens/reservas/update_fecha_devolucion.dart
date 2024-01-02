import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:proyectobibliodac/widgets/appBar.dart';
import 'package:proyectobibliodac/services/reservas.dart';

import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class update_fecha_devolucion extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _update();
}

class _update extends State<update_fecha_devolucion>{
  String anio = "";
  String mes = "";
  String dia = "";
  String fecha_hoy = "";

  List<String> list_anio = [];
  List<String> list_meses = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","setiembre","octubre","noviembre","diciembre"];
  List<String> list_dia = [];

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

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

    return Scaffold(
      appBar: AppBar_default(titulo: "CAMBIAR FECHA DE DEVOLUCIÓN",),
      backgroundColor: Colors.black,
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Center(child: Text("CAMBIAR FECHA", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  ),
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
                  ),
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
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                padding: EdgeInsets.only(right: 25, left: 25, top: 5, bottom: 5),
                child: Text("Actualizar Fecha de Devolución", style: TextStyle(color: Colors.white, fontSize: 25),),
                color: Colors.indigo,
                onPressed: () async{
                  String fecha_devolucion = dia+" "+mes+" "+anio;

                  await update_FechaDevolucion(arguments["id"], fecha_devolucion);
                  Navigator.pushNamed(context, '/reservas_home');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}