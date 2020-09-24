import 'package:chatme/customwidgets/alertcustom.dart';
import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../constantes.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utilizador.dart';

class TelaRegisto extends StatefulWidget {
  static const String id = 'tela_registar';
  @override
  _TelaRegistoState createState() => _TelaRegistoState();
}

class _TelaRegistoState extends State<TelaRegisto> {
  Utilizador utilizador = Utilizador();
  TextEditingController _nomeControl = TextEditingController();
  TextEditingController _emailControl = TextEditingController();
  TextEditingController _passwordControl = TextEditingController();
  TextEditingController _passverificaControl = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appbar(
        onPress: () => Navigator.popAndPushNamed(context, '/'),
      ), // _appbar
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              textFieldCustom(
                control: _nomeControl,
                esconderTexto: false,
                icone: Icons.person_outline,
                textoHint: 'Nome',
                onChange: (value) {
                  utilizador.email = value;
                },
              ),
              textFieldCustom(
                  control: _emailControl,
                  esconderTexto: false,
                  icone: Icons.mail_outline,
                  textoHint: 'Email',
                  textInput: TextInputType.emailAddress,
                  onChange: (value) {
                    utilizador.email = value;
                  }),
              textFieldCustom(
                  control: _passwordControl,
                  esconderTexto: true,
                  icone: Icons.lock_outline,
                  textoHint: 'Password',
                  onChange: (value) {
                    utilizador.password = value;
                  }),
              textFieldCustom(
                  control: _passverificaControl,
                  esconderTexto: true,
                  icone: Icons.lock_outline,
                  textoHint: 'Verificar password',
                  onChange: (value) {
                    utilizador.passverifica = value;
                  }),
              outlineButtonCustom(
                texto: 'Criar Conta',
                onPress: () async {
                  //TODO: REGISTAR COM DADOS DAS TEXTFIELD
                  if (_passwordControl.text == _passverificaControl.text &&
                      _passwordControl.text.length >= 6) {
                    try {
                      final novoUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: utilizador.email,
                              password: utilizador.password);
                    } catch (e) {
                      print(e);
                    }
                    _passwordControl.clear();
                    _passverificaControl.clear();
                    _nomeControl.clear();
                    _emailControl.clear();
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return alertaDialog(
                          titulo: 'Erro!',
                          msgerro: _passwordControl.text.length < 6
                              ? 'A password tem que ter mais de 6 caractéres.'
                              : 'As passwords não coincidem.',
                          onPress: () {
                            _passwordControl.clear();
                            _passverificaControl.clear();
                            Navigator.pop(context);
                          },
                        );
                      },
                      barrierDismissible: true,
                    );
                  }
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'images/back_bottom.png',
                ),
              )
            ],
          ),
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
