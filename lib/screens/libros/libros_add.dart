import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:proyectobibliodac/services/libros.dart';

import 'package:proyectobibliodac/widgets/appBar.dart';
import 'package:proyectobibliodac/widgets/input_decoration.dart';


class libro_add extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _libroAdd();
}

class _libroAdd extends State<libro_add>{

  TextEditingController titulo = TextEditingController(text: "");
  TextEditingController autor = TextEditingController(text: "");
  TextEditingController stock = TextEditingController(text: "");

  File? pic;

  Future<XFile?> getImage() async{
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar_default(titulo: "REGISTRAR LIBRO",),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: titulo,
                  style: TextStyle(color: Colors.indigo, fontSize: 25),
                  decoration: InputDecorations.authInputDecoration(
                    labelText: "Titulo",
                    prefixIcon: Icons.abc,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: autor,
                  style: TextStyle(color: Colors.indigo, fontSize: 25),
                  decoration: InputDecorations.authInputDecoration(
                    labelText: "Autor",
                    prefixIcon: Icons.abc,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: stock,
                  style: TextStyle(color: Colors.indigo, fontSize: 25),
                  decoration: InputDecorations.authInputDecoration(
                    labelText: "Stock",
                    prefixIcon: Icons.numbers,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                ElevatedButton(
                  onPressed: () async{
                    final XFile? image = await getImage();
                    setState(() {
                      pic = File(image!.path);
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
                  String l_autor = autor.text;
                  String l_titulo = titulo.text;
                  int l_stock = int.parse(stock.text);

                  List data = [l_autor,l_titulo,l_stock,pic];
                  print(data);
                  await addLibro(data).then((_) {
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

