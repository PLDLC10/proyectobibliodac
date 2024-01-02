import 'package:flutter/material.dart';
import 'package:proyectobibliodac/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/date_symbol_data_local.dart';

import 'package:proyectobibliodac/screens/login_screen.dart';
import 'package:proyectobibliodac/screens/home.dart';
import 'package:proyectobibliodac/screens/libros/libros_home.dart';
import 'package:proyectobibliodac/screens/libros/libros_add.dart';
import 'package:proyectobibliodac/screens/libros/libros_edit.dart';

import 'package:proyectobibliodac/screens/usuarios/usuarios_home.dart';
import 'package:proyectobibliodac/screens/usuarios/usuarios_add.dart';
import 'package:proyectobibliodac/screens/usuarios/usuarios_edit.dart';

import 'package:proyectobibliodac/screens/reservas/reservar_libro.dart';
import 'package:proyectobibliodac/screens/reservas/reservas_home.dart';
import 'package:proyectobibliodac/screens/reservas/reservas_add.dart';
import 'package:proyectobibliodac/screens/reservas/reservas_edit.dart';
import 'package:proyectobibliodac/screens/reservas/update_fecha_devolucion.dart';

import 'package:proyectobibliodac/providers/sesion.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting('es', null);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => Sesion(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginScreen(),
        '/home': (_) => HomeScreen(),
        '/libros': (_) => libros_Home(),
        '/libros_add': (_) => libro_add(),
        '/libros_edit': (_) => libro_edit(),
        '/usuarios': (_) => usuarios_Home(),
        '/usuarios_add': (_) => usuario_add(),
        '/usuarios_edit': (_) => usuario_edit(),
        '/reservar_libro': (_) => reservar_libro(),
        '/reservas_home': (_) => reservas_home(),
        '/reservas_add': (_) => reserva_add(),
        '/reservas_edit': (_) => reserva_edit(),
        '/update_fecha_devolucion': (_) => update_fecha_devolucion(),
      },
      theme:
          ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.grey[300]),
    );
  }
}
