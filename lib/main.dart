import 'package:chatme/telas/telalogin.dart';
import 'package:chatme/telas/telamensagens.dart';
import 'package:chatme/telas/telaregisto.dart';
import 'package:flutter/material.dart';

import 'constantes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        primaryColorDark: Colors.white,
        buttonColor: corBotao,
        fontFamily: 'Ubuntu-Regular',
        scaffoldBackgroundColor: corScaffold,
        cardColor: corUserMsg,
        buttonTheme: ButtonThemeData(
          buttonColor: corBotao,
        ),
      ),
      initialRoute: TelaLogin.id,
      routes: {
        TelaLogin.id: (context) => TelaLogin(),
        TelaMensagens.id: (context) => TelaMensagens(),
        TelaRegisto.id: (context) => TelaRegisto(),
      },
    );
  }
}
