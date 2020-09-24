import 'package:chatme/constantes.dart';
import 'package:chatme/customwidgets/textstylescustom.dart';
import 'package:flutter/material.dart';

AlertDialog alertaDialog({String titulo, String msgerro, Function onPress}) {
  return AlertDialog(
    backgroundColor: corBotao,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    title: ListTile(
      leading: Icon(
        Icons.error_outline,
        color: Colors.black,
        size: 30.0,
      ),
      title: Text(
        titulo,
        style: textFieldStyle(
          tamanho: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    content: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning,
            size: 60.0,
            color: Colors.black,
          ),
          Text(
            msgerro,
            style: textFieldStyle(
              tamanho: 20.0,
            ),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      RaisedButton(
        child: Text('OK'),
        onPressed: onPress,
      )
    ],
  );
}
