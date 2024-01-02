
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:proyectobibliodac/widgets/appBar.dart';
import 'package:proyectobibliodac/widgets/menu_lateral.dart';
import 'package:proyectobibliodac/widgets/input_decoration.dart';

import 'package:proyectobibliodac/services/libros.dart';

class libros_Home extends StatefulWidget{
  @override
  State<libros_Home> createState() => _librosHome();
}

class _librosHome extends State<libros_Home>{
  bool busqueda = false;
  final termino = TextEditingController();
  String titulo = "LISTA DE LIBROS";

  void recargarPagina() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar_default(titulo: "LIBROS",),
      drawer: MenuLateral(),
      floatingActionButton: FloatingActionButton(
          onPressed: () async{
            await Navigator.pushNamed(context, '/libros_add');
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
                            labelText: 'Ingrese título de un libro',
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
                              titulo = "LISTA DE LIBROS";
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
              Lista(callback: recargarPagina, lista: searchLibro(termino.text),)
              :
              Lista(callback: recargarPagina, lista: getLibro())
        ],
      ),
    );
  }
}

// LISTA DE LIBROS

class Lista extends StatelessWidget {
  final VoidCallback callback;
  late Future<List> lista;
  String url_default = "https://firebasestorage.googleapis.com/v0/b/db-bibliodac.appspot.com/o/portadas_libro%2Fdefault_libro.jpg?alt=media&token=c5310416-1628-4384-8a58-28642ed7703b";

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
                  String titulo = snapshot.data?[index]['titulo'];
                  String autor = snapshot.data?[index]['autor'];
                  String stock = snapshot.data![index]['stock'].toString();
                  String imagen = snapshot.data?[index]['imagen'];
                  String id = snapshot.data?[index]['id'];

                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    key: Key(id),
                    onDismissed: (direction) async{
                      await deleteLibro(id);
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
                                child:
                                const Center(child: CircularProgressIndicator()),
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
                    onTap: (() async{
                      await Navigator.pushNamed(context, '/libros_edit', arguments: {
                        "titulo": titulo,
                        "autor": autor,
                        "stock": stock,
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