import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBar_default extends StatelessWidget implements PreferredSizeWidget{

  String titulo;

  AppBar_default({
    required this.titulo
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo),
      backgroundColor: Colors.amber,
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child:Padding(
              padding:EdgeInsets.all(5),
              child:  Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/logo_dac.png"),
                        fit: BoxFit.fill
                    )
                ),
              ),
            )
          )
        ],
      ),
    );
  }

}

