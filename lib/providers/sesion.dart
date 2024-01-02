import 'package:flutter/material.dart';

class Sesion extends ChangeNotifier{
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String id = '';
  String nombre = '';
  String username='';
  String pass='';
  String imagen='';
  String tipo='';

  void setSesion(String s_id, String s_nombre, String s_tipo, String s_username, String s_pass, String s_imagen){
    username = s_username;
    pass = s_pass;
    id = s_id;
    nombre = s_nombre;
    tipo = s_tipo;
    imagen = s_imagen;
    notifyListeners();
  }
}