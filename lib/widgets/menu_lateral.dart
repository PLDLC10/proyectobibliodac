import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyectobibliodac/providers/sesion.dart';
import 'package:provider/provider.dart';

class MenuLateral extends StatefulWidget{
  @override
  _MenuState createState()=> _MenuState();
}

class _MenuState extends State<MenuLateral>{
  @override


  Widget build(BuildContext context) {
    final userProvider = Provider.of<Sesion>(context, listen: false);

    return Drawer(
      child: Container(
        color: Colors.grey[300],
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              color: Colors.yellow,
              child: Stack(
                children: [
                  const Center(child: CircularProgressIndicator()),
                  Center(
                    child: Image.network(
                      userProvider.imagen == "" ?
                      "https://firebasestorage.googleapis.com/v0/b/db-bibliodac.appspot.com/o/perfil_usuario%2Fuser_default.jpg?alt=media&token=ba48793b-f63c-440c-b06f-586e70444e97"
                          :
                      userProvider.imagen,
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Icon(Icons.error);
                      },
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 0,
                    child: Container(
                      width: 100,
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Text(" "+userProvider.username+" ", style: TextStyle(color: Colors.black)),
                          ),
                          Container(
                            color: Colors.white,
                            child: Text(" "+userProvider.nombre+" ", style: TextStyle(color: Colors.black),),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
            ListTile(
              title: Text("Home"),
              onTap: (){
                Navigator.pushNamed(context, '/home');
              },
            ),
            userProvider.tipo == "ADMIN" ?
            ListTile(
              title: Text("Gestionar Libros"),
              onTap: (){
                Navigator.pushNamed(context, '/libros');
              },
            ): Container(),
            userProvider.tipo == "ADMIN" ?
            ListTile(
              title: Text("Gestionar Usuarios"),
              onTap: (){
                Navigator.pushNamed(context, '/usuarios');
              },
            ): Container(),
            userProvider.tipo == "ADMIN" ?
            ListTile(
              title: Text("Gestionar Reservas"),
              onTap: (){
                Navigator.pushNamed(context, '/reservas_home');
              },
            ): Container(),

            ListTile(
              title: Text("Mi Perfil"),
              onTap: (){
                Navigator.pushNamed(context, '/usuarios_edit', arguments: {
                  "nombre": userProvider.nombre,
                  "pass": userProvider.pass,
                  "tipo": userProvider.tipo,
                  "username": userProvider.username,
                  "imagen": userProvider.imagen,
                  "id": userProvider.id
                });
              },
            ),

            userProvider.tipo == "ALUMNO" ?
            ListTile(
              title: Text("Reservar Libro"),
              onTap: (){
                Navigator.pushNamed(context, '/reservar_libro');
              },
            ): Container(),

            userProvider.tipo == "ALUMNO" ?
            ListTile(
              title: Text("Mis Reservas"),
              onTap: (){
                Navigator.pushNamed(context, '/reservas_home');
              },
            ): Container(),



            ListTile(
              title: Text("Logout"),
              onTap: (){
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      )
    );
  }
  
}