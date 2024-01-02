import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/menu_lateral.dart';
import '../widgets/appBar.dart';
import 'package:proyectobibliodac/providers/sesion.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget texto_inicial() {
      final userProvider = Provider.of<Sesion>(context, listen: false);
      return Text(
        userProvider.nombre,
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      );
    }

    return Scaffold(
      appBar: AppBar_default(titulo: "PÁGINA PRINCIPAL"),
      drawer: MenuLateral(),
      backgroundColor: CupertinoColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("BIENVENIDO AL APLICATIVO BIBLIODAC",
                style: TextStyle(
                    color: CupertinoColors.systemGreen, fontSize: 20)),
            SizedBox(
              height: 30,
            ),
            texto_inicial(),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      "LOGOUT",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                })
          ],
        ),
      ),
    );
  }
}
