import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../constantes.dart';

class TelaRegisto extends StatefulWidget {
  static const String id = 'tela_registar';
  @override
  _TelaRegistoState createState() => _TelaRegistoState();
}

class _TelaRegistoState extends State<TelaRegisto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appbar(
        onPress: () => Navigator.popAndPushNamed(context, '/'),
      ), // _appbar
      body: SafeArea(
        child: Column(
          children: <Widget>[
            textFieldCustom(
              padHorizontal: 16.0,
              padVertical: 8.0,
              esconderTexto: false,
              icone: Icons.person_outline,
              textoHint: 'Nome',
            ),
            textFieldCustom(
              padHorizontal: 16.0,
              padVertical: 8.0,
              esconderTexto: false,
              icone: Icons.mail_outline,
              textoHint: 'Email',
            ),
            textFieldCustom(
              padHorizontal: 16.0,
              padVertical: 8.0,
              esconderTexto: true,
              icone: Icons.lock_outline,
              textoHint: 'Password',
            ),
            outlineButtonCustom(
              texto: 'Criar Conta',
              onPress: () {
                //TODO: REGISTAR COM DADOS DAS TEXTFIELD
              },
            ),
            separador,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                customIconButton(
                  icone: FontAwesomeIcons.google,
                  cor: corBotao,
                  tamanho: 30.0,
                  onPress: () {
                    //TODO: REGISTAR COM GOOGLE
                  },
                ),
                SizedBox(
                  width: 15.0,
                ),
                customIconButton(
                  icone: FontAwesomeIcons.facebook,
                  cor: corBotao,
                  tamanho: 30.0,
                  onPress: () {
                    //TODO: REGISTAR COM FACEBOOK
                  },
                ),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/back_bottom.png',
              ),
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
