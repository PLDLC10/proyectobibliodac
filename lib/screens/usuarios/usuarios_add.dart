import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:proyectobibliodac/services/usuarios.dart';

import 'package:proyectobibliodac/widgets/appBar.dart';
import 'package:proyectobibliodac/widgets/input_decoration.dart';


class usuario_add extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _usuarioAdd();
}

class _usuarioAdd extends State<usuario_add>{

  TextEditingController nombre = TextEditingController(text: "");
  TextEditingController pass = TextEditingController(text: "");
  TextEditingController username = TextEditingController(text: "");
  String tipo = '--- Tipo de Usuario ---';

  File? pic;

  Future<XFile?> getImage() async{
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar_default(titulo: "REGISTRAR USUARIO",),
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
                    labelText: "Password",
                    prefixIcon: Icons.key,
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
                    prefixIcon: Icons.abc,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
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
                          print(tipo); // Imprime el texto de la opción seleccionada
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
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async{
                    final XFile? image = await getImage();
                    setState(() {
                      pic = File(image!.path);
                    });
                  },
                  child: Text("Seleccione una foto de perfil"),
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
                  pic == null?
                  Center(child: Text("No hay imagen", style: TextStyle(color: Colors.white),))
                      :
                  Container(
                      height: 150,
                      width: 150,
                      child: Image.file(pic!, fit: BoxFit.fill,)
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(onPressed: () async{
                  String l_nombre = nombre.text;
                  String l_pass = pass.text;
                  String l_tipo = tipo;
                  String l_username = username.text;

                  List data = [l_nombre,l_pass, l_tipo, l_username,pic];
                  await addUsuario(data).then((_) {
                    Navigator.pop(context);
                  });
                }, child: Text('Registrar'))
              ],
            ),
          ),
        )
    );
  }

}

