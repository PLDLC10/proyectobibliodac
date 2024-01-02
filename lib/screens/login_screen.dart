import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectobibliodac/providers/sesion.dart';
import 'package:proyectobibliodac/services/usuarios.dart';

import 'package:proyectobibliodac/services/reservas.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.srcOver,
                ),
                image: AssetImage('images/fondo_login.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/logo_dac.png"),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  CardContainer(
                      child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text('Login',
                          style: Theme.of(context).textTheme.headlineMedium),
                      SizedBox(height: 30),
                      _LoginForm()
                    ],
                  )),
                  SizedBox(height: 50),
                  Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  Text(
                    'Comunícate con el administrador: 910 049 895',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  SizedBox(height: 125),
                ],
              ),
            )));
  }
}

class _LoginForm extends StatelessWidget {
  String username = "";
  String pass = "";

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<Sesion>(context);

    return Container(
      child: Form(
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '', labelText: 'Usuario', prefixIcon: Icons.person),
              onChanged: (value) => username = value,
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              // keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock),
              onChanged: (value) => pass = value,
            ),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.green,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      "Ingresar",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )),
                onPressed: () async {
                  //addReserva(["13ki6Ed23iUbPkoSVqSl", "OdXRm0pOKdHqrYGFmIds"]);

                  List data = await searchUsuario(username);
                  if (data.isNotEmpty && data[0]['pass'] == pass) {
                    loginForm.setSesion(
                        data[0]['id'],
                        data[0]['nombre'],
                        data[0]['tipo'],
                        data[0]['username'],
                        data[0]['pass'],
                        data[0]['imagen']);
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    print(username + "|||" + pass);
                    print(username);

                    print("DATOS INCORRECTOS");
                  }
                })
          ],
        ),
      ),
    );
  }
}

//DECORACION
class CardContainer extends StatelessWidget {
  final Widget child;
  const CardContainer({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: _CreateCardShape(),
        child: this.child,
      ),
    );
  }

  BoxDecoration _CreateCardShape() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 5),
            )
          ]);
}

class InputDecorations {
  static InputDecoration authInputDecoration(
      {required String hintText,
      required String labelText,
      IconData? prefixIcon}) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2)),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey, fontSize: 25),
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.green) : null);
  }
}
