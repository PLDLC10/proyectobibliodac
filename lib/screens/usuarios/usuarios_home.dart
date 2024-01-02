
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:proyectobibliodac/widgets/appBar.dart';
import 'package:proyectobibliodac/widgets/menu_lateral.dart';
import 'package:proyectobibliodac/widgets/input_decoration.dart';

import 'package:proyectobibliodac/services/usuarios.dart';

class usuarios_Home extends StatefulWidget{
  @override
  State<usuarios_Home> createState() => _usuariosHome();
}

class _usuariosHome extends State<usuarios_Home>{
  bool busqueda = false;
  final termino = TextEditingController();
  String titulo = "LISTA DE USUARIOS";

  void recargarPagina() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar_default(titulo: "USUARIOS",),
      drawer: MenuLateral(),
      floatingActionButton: FloatingActionButton(
          onPressed: () async{
            await Navigator.pushNamed(context, '/usuarios_add');
            setState(() {});
          },
        child: Icon(Icons.add),
      ),
      backgroundColor: CupertinoColors.black,

      body: Column(
        children: [
          // CAJON DE BUSQUEDA
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
                            labelText: 'Ingrese un nombre de Usuario',
                            prefixIcon: Icons.person,
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
                              titulo = "Resultados de Busqueda";
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
                              titulo = "LISTA DE USUARIOS";
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
          ),
          SizedBox(
            height: 50,
          ),
          Text(titulo, style: TextStyle(color: Colors.deepPurple, fontSize: 20, fontWeight: FontWeight.bold),),
          busqueda == true ?
              Lista(callback: recargarPagina, lista: searchUsuario(termino.text),)
              :
              Lista(callback: recargarPagina, lista: getUsuario())
        ],
      ),
    );
  }
}

// LISTA DE USUARIOS
class Lista extends StatelessWidget {
  final VoidCallback callback;
  late Future<List> lista;
  String url_default = "https://firebasestorage.googleapis.com/v0/b/db-bibliodac.appspot.com/o/perfil_usuario%2Fuser_default.jpg?alt=media&token=ba48793b-f63c-440c-b06f-586e70444e97";

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
                  String nombre = snapshot.data?[index]['nombre'];
                  String pass = snapshot.data?[index]['pass'];
                  String tipo = snapshot.data![index]['tipo'];
                  String imagen = snapshot.data?[index]['imagen'];
                  String username = snapshot.data?[index]['username'];
                  String id = snapshot.data?[index]['id'];

                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    key: Key(id),
                    onDismissed: (direction) async{
                      await deleteUsuario(id);
                      snapshot.data?.removeAt(index);
                    },

                    confirmDismiss: (direction) async{
                      bool result = false;
                      result = await showDialog(
                          context: context,
                          builder:(context){
                            return AlertDialog(
                              title: Text("¿Está seguro de elimiar el registro?"),
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
                          });
                      return result;
                    },
                    background: Container(
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.delete),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        )
                    ),

                    child: Container(
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
                                    Text("Nombre: "+nombre, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text("Tipo de Usuario: "+tipo, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900),),
                                    Text("Username: "+username, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    onTap: (() async{
                      await Navigator.pushNamed(context, '/usuarios_edit', arguments: {
                        "nombre": nombre,
                        "pass": pass,
                        "tipo": tipo,
                        "username": username,
                        "imagen": imagen,
                        "id": id
                      });
                      callback();
                    }),
                  ),
                    )
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