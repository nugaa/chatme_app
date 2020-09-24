import 'package:chatme/telas/telalogin.dart';
import 'package:chatme/telas/telamensagens.dart';
import 'package:chatme/telas/telaregisto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'constantes.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _iniciar = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _iniciar = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      print('Erro!');
    }

    // Show a loader until FlutterFire is initialized
    if (!_iniciar) {
      return Center(child: CircularProgressIndicator());
    }

    return MaterialApp(
      theme: _tema,
      initialRoute: TelaLogin.id,
      routes: {
        TelaLogin.id: (context) => TelaLogin(),
        TelaMensagens.id: (context) => TelaMensagens(),
        TelaRegisto.id: (context) => TelaRegisto(),
      },
    );
  }
}

ThemeData _tema = ThemeData(
  primaryColor: Colors.white,
  primaryColorDark: Colors.white,
  buttonColor: corBotao,
  fontFamily: 'Ubuntu-Regular',
  scaffoldBackgroundColor: corScaffold,
  cardColor: corUserMsg,
  buttonTheme: ButtonThemeData(
    buttonColor: corBotao,
  ),
);
