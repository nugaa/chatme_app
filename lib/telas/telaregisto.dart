import 'package:flutter/material.dart';

import '../constantes.dart';

class TelaRegisto extends StatefulWidget {
  @override
  _TelaRegistoState createState() => _TelaRegistoState();
}

class _TelaRegistoState extends State<TelaRegisto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(
        onPress: () => Navigator.popAndPushNamed(context, '/'),
      ), // _appbar
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Image.asset(
              'images/back_bottom.png',
            )
          ],
        ),
      ),
    );
  }
}

Widget _appbar({Function onPress}) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: corScaffold,
    leading: IconButton(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      icon: Icon(
        Icons.arrow_back_ios,
        color: corBotao,
      ),
      onPressed: onPress,
    ),
  );
}
