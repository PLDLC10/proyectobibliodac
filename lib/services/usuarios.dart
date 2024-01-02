import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

Future<List> getUsuario() async {
  List usuario = [];
  CollectionReference collectionReferenceUsuario = db.collection("usuarios");
  QuerySnapshot queryUsuario = await collectionReferenceUsuario.get();

  for (var element in queryUsuario.docs){
    Map<String, dynamic> data = element.data() as Map<String,dynamic>;

    final f_usuario = {
      "nombre": data['nombre'],
      "pass": data['pass'],
      "tipo": data['tipo'],
      "username": data['username'],
      "imagen": data['imagen'],
      "id": element.id,
    };

    usuario.add(f_usuario);
  }
  return usuario;
}

Future<void> addUsuario(List data) async{

  String url;
  if(data[4] == null){
    url = "";
  }else{
    String nom_imagen = data[3]+"_perfil.jpg";
    url = await uploadImage(data[4], nom_imagen);
  }

  await db.collection("usuarios").add({
    "nombre": data[0],
    "pass": data[1],
    "tipo": data[2],
    "username": data[3],
    "imagen": url
  });
}

Future<String> editUsuario(String id, List data) async{
  String url = "";

  if (data[4] == null){
    url = data[5];
  }else{
    String nom_imagen = data[3]+"_portada.jpg";
    url = await uploadImage(data[4], nom_imagen);
  }

  await db.collection("usuarios").doc(id).set({
    "nombre": data[0],
    "pass": data[1],
    "tipo": data[2],
    "username": data[3],
    "imagen": url
  });
  return url;
}

Future<void> deleteUsuario(String id) async{
  await db.collection("usuarios").doc(id).delete();
}

Future<List> searchUsuario(String busq) async{
  List usuario = [];

  CollectionReference UsuariosRef = FirebaseFirestore.instance.collection('usuarios');

  QuerySnapshot queryUsuarios = await UsuariosRef.where('username', isEqualTo: busq).get();

  for (QueryDocumentSnapshot element in queryUsuarios.docs) {
    Map<String, dynamic> data = element.data() as Map<String, dynamic>;
    final f_usuario = {
      "nombre": data['nombre'],
      "pass": data['pass'],
      "tipo": data['tipo'],
      "username": data['username'],
      "imagen": data['imagen'],
      "id": element.id,
    };
    usuario.add(f_usuario);
  }
  return usuario;
}

Future<String> uploadImage(File image, String nombre_imagen) async{
  final Reference ref = storage.ref().child("perfil_usuario").child(nombre_imagen);
  final uploadTask = ref.putFile(image);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  final String url = await snapshot.ref.getDownloadURL();
  return url;
}

Future<String> getUrl (String ruta) async{
  final Reference ref = storage.ref().child("perfil_usuario/").child(ruta);
  final String url = await ref.getDownloadURL();
  print(url);
  return url;
}