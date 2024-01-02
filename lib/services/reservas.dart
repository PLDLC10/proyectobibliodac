import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:proyectobibliodac/services/libros.dart';
import 'package:proyectobibliodac/services/usuarios.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

Future<List> getReserva() async {
  List reserva = [];
  CollectionReference collectionReferenceReserva = db.collection("reservas");
  QuerySnapshot queryReserva;

  queryReserva = await collectionReferenceReserva.get();

  for (var element in queryReserva.docs){
    Map<String, dynamic> data = element.data() as Map<String,dynamic>;
    String id_libro = data['id_libro'];
    String id_usuario = data['id_usuario'];

    DocumentSnapshot libroDocumentSnapshot = await db.collection('libros').doc(id_libro).get();
    String nombreLibro = libroDocumentSnapshot['titulo'];
    String imagen = libroDocumentSnapshot['imagen'];
    String autor = libroDocumentSnapshot['autor'];

    DocumentSnapshot usuarioDocumentSnapshot = await db.collection('usuarios').doc(id_usuario).get();
    String user = usuarioDocumentSnapshot['username'];

    final f_libro = {
      "fecha_reserva": data['fecha_reserva'],
      "fecha_prestamo": data['fecha_prestamo'],
      "fecha_devolucion": data['fecha_devolucion'],
      "estado": data["estado"],
      "nombreLibro": nombreLibro,
      "imagen": imagen,
      "autor": autor,
      "username": user,
      "id": element.id,
      "id_libro": data['id_libro'],
    };
    reserva.add(f_libro);
  }
  return reserva;
}

Future<List> getReservaXUsuario(String username) async{
  String id_usuario = "";
  CollectionReference UsuariosRef = FirebaseFirestore.instance.collection('usuarios');
  QuerySnapshot queryUsuarios = await UsuariosRef.where('username', isEqualTo: username).get();
  for (QueryDocumentSnapshot element in queryUsuarios.docs) {
    id_usuario = element.id;
  }


  List reserva = [];
  CollectionReference collectionReferenceReserva = db.collection("reservas");
  QuerySnapshot queryReserva;

  queryReserva = await collectionReferenceReserva.where('id_usuario', isEqualTo: id_usuario).get();

  for (var element in queryReserva.docs){
    Map<String, dynamic> data = element.data() as Map<String,dynamic>;
    String id_libro = data['id_libro'];

    DocumentSnapshot libroDocumentSnapshot = await db.collection('libros').doc(id_libro).get();
    String nombreLibro = libroDocumentSnapshot['titulo'];
    String imagen = libroDocumentSnapshot['imagen'];
    String autor = libroDocumentSnapshot['autor'];

    final f_libro = {
      "fecha_reserva": data['fecha_reserva'],
      "fecha_prestamo": data['fecha_prestamo'],
      "fecha_devolucion": data['fecha_devolucion'],
      "estado": data["estado"],
      "autor": autor,
      "nombreLibro": nombreLibro,
      "imagen": imagen,
      "username": username,
      "id": element.id,
      "id_libro": data['id_libro'],
    };

    reserva.add(f_libro);
  }
  return reserva;
}

Future<void> addReserva(List data) async{
  updateStock(data[0], -1);

  await db.collection("reservas").add({
    "id_libro": data[0],
    "id_usuario": data[1],
    "fecha_reserva": data[2],
    "fecha_prestamo": "",
    "fecha_devolucion": "",
    "estado": "Reservado",
  });
}

Future<void> update_Prestado (String id, List data) async{
  //data[0] fecha de prestamo (hoy)
  //data[1] fecha de devolucion

  DocumentReference documentRef = db.collection("reservas").doc(id);
  DocumentSnapshot snapshot = await documentRef.get();

  if (snapshot.exists){
    documentRef.set({
      "fecha_prestamo" : data[0],
      "fecha_devolucion" : data[1],
      "estado" : "Prestado"
    },SetOptions(merge: true),);
  }else {
    print('El documento no existe');
  }
}

Future<void> update_Devuelto (String id, String id_libro, String fecha) async{

  //fecha == fecha de hoy
  DocumentReference documentRef = db.collection("reservas").doc(id);
  DocumentSnapshot snapshot = await documentRef.get();

  if (snapshot.exists){
    updateStock(id_libro, 1);
    documentRef.set({
      "fecha_devolucion" : fecha,
      "estado" : "Devuelto"
    },SetOptions(merge: true),);
  }else {
    print('El documento no existe');
  }
}

Future<void> update_Cancelado (String id, String id_libro) async{

  DocumentReference documentRef = db.collection("reservas").doc(id);
  DocumentSnapshot snapshot = await documentRef.get();

  if (snapshot.exists){
    updateStock(id_libro, 1);
    documentRef.set({
      "estado" : "Cancelado"
    },SetOptions(merge: true),);
  }else {
    print('El documento no existe');
  }
}

Future<void> update_FechaDevolucion (String id, String fecha) async{
  DocumentReference documentRef = db.collection("reservas").doc(id);
  DocumentSnapshot snapshot = await documentRef.get();

  if (snapshot.exists){
    documentRef.set({
      "fecha_devolucion" : fecha,
    },SetOptions(merge: true),);
  }else {
    print('El documento no existe');
  }
}

