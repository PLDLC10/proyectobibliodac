
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyectobibliodac/services/reservas.dart';
import 'package:proyectobibliodac/widgets/appBar.dart';
import 'package:proyectobibliodac/widgets/menu_lateral.dart';
import 'package:proyectobibliodac/widgets/input_decoration.dart';
import 'package:provider/provider.dart';
import 'package:proyectobibliodac/providers/sesion.dart';

class reservas_home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _reservasHome();
}

class _reservasHome extends State<reservas_home>{

  bool busqueda = false;
  final termino = TextEditingController();
  String titulo = "LISTA DE RESERVAS";

  void recargarPagina() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Sesion>(context, listen: false);

    return Scaffold(
      appBar: AppBar_default(titulo: "RESERVAS",),
      drawer: MenuLateral(),
      backgroundColor: CupertinoColors.black,

      body: Column(
        children: [
          // CAJON DE BUSQUEDA
          userProvider.tipo == "ADMIN" ?
          Padding(
              padding: EdgeInsets.all(15),
              //child: Text("asd", style: TextStyle(color: Colors.white),),
              child: Card(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Text('BUSQUEDA', style: TextStyle(color: Colors.deepPurple, fontSize: 20, fontWeight: FontWeight.bold),),
                      Row(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Expanded(
                            child: TextField(
                              controller: termino,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 25
                              ),
                              decoration: InputDecorations.authInputDecoration(
                                labelText: 'Ingrese nombre de usuario',
                                prefixIcon: Icons.book,
                              ),
                            ),
                          ),
                          Text("       "),
                          Container(
                            height: 50,
                            width: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  busqueda= true;
                                  titulo = "RESULTADOS DE BUSQUEDA";
                                });
                              },
                              child: Icon(Icons.search),
                            ),
                          ),
                          Text("  "),
                          Container(
                            height: 50,
                            width: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  busqueda= false;
                                  titulo = "LISTA DE RESERVAS";
                                });
                              },
                              child: Icon(Icons.refresh),
                            ),
                          ),
                          Text("  "),
                        ],
                      ),
                    ],
                  )
              )
          ): Container(),
          SizedBox(
            height: 50,
          ),
          Text(titulo, style: TextStyle(color: Colors.deepPurple, fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(
            height: 25,
          ),
          busqueda == true ?
          Lista(callback: recargarPagina, lista: getReservaXUsuario(termino.text),)
              :
          userProvider.tipo == "ALUMNO" ?
          Lista(callback: recargarPagina, lista: getReservaXUsuario(userProvider.username))
              :
          Lista(callback: recargarPagina, lista: getReserva()),

        ],
      ),
    );
  }
}


class Lista extends StatelessWidget {
  final VoidCallback callback;
  late Future<List> lista;

  Lista({
    required this.callback,
    required this.lista
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: lista,
        builder: ((context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index){
                  String id = snapshot.data?[index]['id'];
                  String autor = snapshot.data?[index]['autor'];
                  String imagen = snapshot.data?[index]['imagen'];
                  String estado = snapshot.data?[index]['estado'];
                  String username = snapshot.data?[index]['username'];
                  String id_libro = snapshot.data?[index]['id_libro'];
                  String nombreLibro = snapshot.data?[index]['nombreLibro'];
                  String fecha_reserva = snapshot.data?[index]['fecha_reserva'];
                  String fecha_prestamo = snapshot.data?[index]['fecha_prestamo'];
                  String fecha_devolucion = snapshot.data![index]['fecha_devolucion'];

                  return Container(
                    padding: EdgeInsets.only(left: 20,right: 20, bottom: 5, top: 5),
                    child: ListTile(
                      title: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Row(
                          children: [

                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Usuario: "+username, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                                  Text("Libro: "+nombreLibro + "\n", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),),
                                  Text("Fecha de Reserva: "+fecha_reserva, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900),),
                                  estado != "Cancelado" ?
                                  Text(
                                    fecha_prestamo != "" ?
                                    "Fecha de Préstamo: "+fecha_prestamo
                                    :
                                    "Fecha de Préstamo: Libro aún no prestado"
                                    , style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900),)
                                  : Container(),
                                  estado != "Cancelado" ?
                                  Text(
                                    fecha_devolucion != "" ?
                                    "Fecha de Devolución : "+fecha_devolucion
                                    :
                                    "Fecha de Devolución : Libro aún no devuelto"
                                    , style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900),)
                                      : Container(),
                                ],
                              ),
                            ),
                            Container(
                              width: 100,
                              child:
                              Center(child: Text(estado, style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),),),
                              decoration: BoxDecoration(
                                color:
                                estado == "Reservado" ? Colors.blue
                                : estado == "Prestado" ? Colors.green
                                : estado == "Devuelto" ? Colors.orange
                                : estado == "Cancelado" ? Colors.red
                                : Colors.black,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: (() async{
                        await Navigator.pushNamed(context, '/reservas_edit', arguments: {
                          "id": id,
                          "id_libro": id_libro,
                          "username": username,
                          "fecha_reserva": fecha_reserva,
                          "fecha_prestamo": fecha_prestamo,
                          "fecha_devolucion": fecha_devolucion,
                          "estado": estado,
                          "nombre_libro": nombreLibro,
                          "autor": autor,
                          "imagen": imagen
                        });
                        callback();
                      }),
                    ),
                  );
                }
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}