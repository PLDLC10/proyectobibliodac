
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputDecorations{
  static InputDecoration authInputDecoration({
    required String labelText,
    IconData? prefixIcon
  }) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.green
          ),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green,
                width: 2
            )
        ),
        labelText: labelText,
        labelStyle: TextStyle(
            color: Colors.green,
            fontSize: 20
        ),
        prefixIcon: prefixIcon != null
            ? Icon( prefixIcon, color: Colors.green )
            : null
    );
  }
}