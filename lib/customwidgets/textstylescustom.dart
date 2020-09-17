import 'package:flutter/material.dart';

TextStyle textFieldStyle(
    {@required double tamanho, FontWeight fontWeight, Color cor}) {
  return TextStyle(
    color: cor,
    fontSize: tamanho,
    letterSpacing: 0.5,
    fontWeight: fontWeight,
  );
}
