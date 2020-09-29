import 'package:chatme/comparar_regex.dart';
import 'package:chatme/customwidgets/alertcustom.dart';
import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:chatme/networking/servicos_firebase.dart';
import 'package:chatme/telas/telalogin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constantes.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utilizador.dart';

class TelaRegisto extends StatefulWidget {
  static const String id = 'tela_registar';
  @override
  _TelaRegistoState createState() => _TelaRegistoState();
}

class _TelaRegistoState extends State<TelaRegisto> {
  CompararRegex compararRegex = CompararRegex();
  Utilizador utilizador = Utilizador();
  TextEditingController _nomeControl = TextEditingController();
  TextEditingController _emailControl = TextEditingController();
  TextEditingController _passwordControl = TextEditingController();
  TextEditingController _passverificaControl = TextEditingController();
  Color cor;
  bool showSpinner = false;

  void verificarEmail(String value) {
    if (compararRegex.validarEmail(email: value) == true) {
      utilizador.email = value;
      cor = Colors.white;
    } else {
      cor = Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appbar(
        onPress: () => Navigator.popAndPushNamed(context, TelaLogin.id),
      ), // _appbar
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  setState(() {
                    verificarEmail(value);
                  });
                },
                corDoTexto: cor,
              ),
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
                  //TODO: Falta aproveitar o Nome que está guardado no Utilizador

                  if (_passwordControl.text == _passverificaControl.text &&
                      _passwordControl.text.length >= 6) {
                    setState(() {
                      showSpinner = true;
                    });

                    var mostrar = await ServicosFirebase()
                        .registarEmailPassword(context, utilizador.email,
                            utilizador.password, showSpinner);

                    setState(() {
                      showSpinner = mostrar;
                    });

                    _passwordControl.clear();
                    _passverificaControl.clear();
                    _nomeControl.clear();
                    _emailControl.clear();
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
