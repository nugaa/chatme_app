import 'package:chatme/constantes.dart';
import 'package:chatme/customwidgets/textstylescustom.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

AlertDialog alertaDialog({String titulo, String msgerro, Function onPress}) {
  return AlertDialog(
    elevation: null,
    backgroundColor: corBotao,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: Colors.black26,
        width: 5.0,
      ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Icon(
              FontAwesomeIcons.frown,
              size: 60.0,
              color: Colors.black,
            ),
          ),
          Text(
            msgerro,
            textAlign: TextAlign.center,
            style: textFieldStyle(
              tamanho: 20.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 10.0),
        child: OutlineButton(
          highlightedBorderColor: corBotao,
          color: corBotao,
          splashColor: corUserMsg,
          borderSide: BorderSide(
            width: 2.0,
            color: corScaffold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'OK',
              style: textFieldStyle(tamanho: 16.0, cor: corScaffold),
            ),
          ),
          onPressed: onPress,
        ),
      ),
    ],
  );
}
