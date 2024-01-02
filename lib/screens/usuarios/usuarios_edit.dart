import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'package:proyectobibliodac/services/usuarios.dart';

import 'package:proyectobibliodac/widgets/appBar.dart';
import 'package:proyectobibliodac/widgets/menu_lateral.dart';
import 'package:proyectobibliodac/widgets/input_decoration.dart';

import 'package:proyectobibliodac/providers/sesion.dart';
import 'package:provider/provider.dart';

class usuario_edit extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _usuarioEdit();
}

class _usuarioEdit extends State<usuario_edit>{
  TextEditingController nombre = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController username = TextEditingController();
  String? tipo;
  String pic_base = "";
  String id = "";
  File? pic_nueva;

  Future<XFile?> getImage() async{
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Sesion>(context, listen: false);

    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    id = arguments["id"];
    nombre.text = arguments["nombre"];
    pass.text = arguments["pass"];
    tipo = arguments["tipo"];
    username.text = arguments["username"];
    pic_base = arguments["imagen"];


    return Scaffold(
        appBar: AppBar_default(titulo: "ACTUALIZAR DATOS",),
        backgroundColor: Colors.black,

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: username,
                  style: TextStyle(color: Colors.indigo, fontSize: 25),
                  decoration: InputDecorations.authInputDecoration(
                    labelText: "Username",
                    prefixIcon: Icons.abc,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: pass,
                  style: TextStyle(color: Colors.indigo, fontSize: 25),
                  decoration: InputDecorations.authInputDecoration(
                    labelText: "Pasword",
                    prefixIcon: Icons.abc,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nombre,
                  style: TextStyle(color: Colors.indigo, fontSize: 25),
                  decoration: InputDecorations.authInputDecoration(
                    labelText: "Nombre Completo",
                    prefixIcon: Icons.numbers,
                  ),
                ),

                SizedBox(
                  height: 15,
                ),
                userProvider.tipo == "ADMIN" ?
                Container(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: tipo,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        dropdownColor: Colors.grey[700],
                        onChanged: (String? newValue) {
                          setState(() {
                            tipo = newValue!;
                            arguments["nombre"] = nombre.text;
                            arguments["pass"] = pass.text;
                            arguments["username"] = username.text;
                            arguments["tipo"] = tipo;
                          });
                        },
                        items: <String>[
                          '--- Tipo de Usuario ---',
                          'ADMIN',
                          'ALUMNO',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),
                          );
                        }).toList(),
                      ),
                    )
                ):Container(),

                SizedBox(
                  height: 10,
                ),

                ElevatedButton(
                  onPressed: () async{
                    final XFile? image = await getImage();
                    setState(() {
                      pic_nueva = File(image!.path);
                      arguments["id"] = id;
                      arguments["nombre"] = nombre.text;
                      arguments["pass"] = pass.text;
                      arguments["tipo"] = tipo;
                      arguments["username"] = username.text;
                    });
                  },
                  child: Text("Seleccione una imagen"),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.indigo,
                      width: 2.0,
                    ),
                  ),
                  child:
                  pic_nueva == null?
                      pic_base == ""?
                        Center(child: Text("No hay imagen", style: TextStyle(color: Colors.white),))
                        :
                        Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(pic_base),
                                    fit: BoxFit.fill
                                )
                            ),
                        )
                  :
                  Container(
                      height: 150,
                      width: 150,
                      child: Image.file(pic_nueva!, fit: BoxFit.fill,)
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(onPressed: () async{
                  String l_nombre = nombre.text;
                  String l_pass = pass.text;
                  String l_username = username.text;

                  List data = [l_nombre,l_pass,tipo,l_username,pic_nueva, pic_base];
                  print(data);

                  String? new_url= await editUsuario(id, data);

                  if(userProvider.id == id){
                    userProvider.id = id;
                    userProvider.nombre = nombre.text;
                    userProvider.pass = pass.text;
                    userProvider.username = username.text;
                    userProvider.tipo = tipo!;
                    userProvider.imagen = new_url!;
                    Navigator.pushNamed(context, "/home");
                  }else{
                    Navigator.pop(context);
                  }

                }, child: Text('Actualizar'))
              ],
            ),
          ),
        )
    );
  }

}

