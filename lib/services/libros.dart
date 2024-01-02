import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;


Future<List> getLibro() async {
  List libro = [];
  CollectionReference collectionReferenceLibro = db.collection("libros");
  QuerySnapshot queryLibro = await collectionReferenceLibro.get();

  for (var element in queryLibro.docs){
    Map<String, dynamic> data = element.data() as Map<String,dynamic>;

    final f_libro = {
      "titulo": data['titulo'],
      "autor": data['autor'],
      "stock": data['stock'],
      "imagen": data['imagen'],
      "id": element.id,
    };

    libro.add(f_libro);
  }
  //updateStock("13ki6Ed23iUbPkoSVqSl", 2);
  return libro;
}

Future<void> addLibro(List data) async{

  String url;
  if(data[3] == null){
    url = "";
  }else{
    String nom_imagen = data[1]+"_portada.jpg";
    url = await uploadImage(data[3], nom_imagen);
  }

  await db.collection("libros").add({
    "autor": data[0],
    "titulo": data[1],
    "stock": data[2],
    "imagen": url
  });
}

Future<void> editLibro(String id, List data) async{
  String url;

  if (data[3] == null){
    url = data[4];
  }else{
    String nom_imagen = data[1]+"_portada.jpg";
    url = await uploadImage(data[3], nom_imagen);
  }

  await db.collection("libros").doc(id).set({
    "autor": data[0],
    "titulo": data[1],
    "stock": data[2],
    "imagen": url
  });
}

Future<void> deleteLibro(String id) async{
  await db.collection("libros").doc(id).delete();
}

Future<List> searchLibro(String titulo) async{
  List libro = [];

  CollectionReference librosRef = FirebaseFirestore.instance.collection('libros');

  QuerySnapshot queryLibros = await librosRef.where('titulo', isEqualTo: titulo).get();

  for (QueryDocumentSnapshot element in queryLibros.docs) {
    Map<String, dynamic> data = element.data() as Map<String, dynamic>;
    final f_libro = {
      "titulo": data['titulo'],
      "autor": data['autor'],
      "stock": data['stock'],
      "imagen": data['imagen'],
      "id": element.id,
    };

    libro.add(f_libro);
  }
  return libro;
}

Future<String> uploadImage(File image, String nombre_imagen) async{
  final Reference ref = storage.ref().child("portadas_libro").child(nombre_imagen);
  final uploadTask = ref.putFile(image);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  final String url = await snapshot.ref.getDownloadURL();
  return url;
}

Future<String> getUrl (String ruta) async{
  final Reference ref = storage.ref().child("portadas_libro/").child(ruta);
  final String url = await ref.getDownloadURL();
  return url;
}


Future<void> updateStock(String id, int incremento) async{

  DocumentReference documentRef = db.collection("libros").doc(id);
  DocumentSnapshot snapshot = await documentRef.get();

  final data = snapshot.data()! as Map<String, dynamic>;
  if (snapshot.exists) {
    int new_stock = data["stock"] + incremento;

    documentRef.set(
      {"stock" : new_stock},
      SetOptions(merge: true),
    );

    print("El nuevo stock es $new_stock");

  } else {
    print('El documento no existe');
  }

}