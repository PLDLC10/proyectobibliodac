import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:proyectobibliodac/services/libros.dart';

import 'package:proyectobibliodac/widgets/appBar.dart';
import 'package:proyectobibliodac/widgets/menu_lateral.dart';
import 'package:proyectobibliodac/widgets/input_decoration.dart';

import 'package:provider/provider.dart';
import 'package:proyectobibliodac/providers/sesion.dart';

class libro_edit extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _libroEdit();
}

class _libroEdit extends State<libro_edit>{
  TextEditingController titulo = TextEditingController();
  TextEditingController autor = TextEditingController();
  TextEditingController stock = TextEditingController();
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
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    id = arguments["id"];
    titulo.text = arguments["titulo"];
    autor.text = arguments["autor"];
    stock.text = arguments["stock"];
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
                      pic_nueva = File(image!.path);
                      arguments["titulo"] = titulo.text;
                      arguments["autor"] = autor.text;
                      arguments["stock"] = stock.text;
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
                  String l_autor = autor.text;
                  String l_titulo = titulo.text;
                  int l_stock = int.parse(stock.text);

                  List data = [l_autor,l_titulo,l_stock,pic_nueva, pic_base];
                  print(data);
                  await editLibro(id, data).then((_) {
                    Navigator.pop(context);
                  });
                }, child: Text('Actualizar'))
              ],
            ),
          ),
        )
    );
  }

}

