import 'package:chatme/comparar_regex.dart';
import 'package:chatme/customwidgets/alertcustom.dart';
import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:chatme/networking/servicos_firebase_auth.dart';
import 'package:chatme/networking/servicos_firestore_database.dart';
import 'package:chatme/telas/telalogin.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constantes.dart';

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
  bool passou = false;

  bool verificarEmail(String value) {
    if (compararRegex.validarEmail(email: value) == true) {
      utilizador.email = value;
      cor = Colors.white;
      passou = true;
      return passou;
    } else {
      cor = Colors.red;
      return passou = false;
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
                  utilizador.nome = value;
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
                  if (_nomeControl.text == null ||
                      _nomeControl.text.length < 3) {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return alertaDialog(
                          titulo: 'Erro!',
                          msgerro: _nomeControl.text.length < 3
                              ? 'Por favor, introduza um nome válido.'
                              : 'Por favor, introduza um nome.',
                          onPress: () {
                            _nomeControl.clear();
                            Navigator.pop(context);
                          },
                        );
                      },
                      barrierDismissible: true,
                    );
                  } else if (passou == false) {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return alertaDialog(
                          titulo: 'Erro!',
                          msgerro: 'Introduza um email válido.',
                          onPress: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                      barrierDismissible: true,
                    );
                  } else if (_passwordControl.text.isEmpty ||
                      _passwordControl.text.length < 6 ||
                      _passwordControl.text != _passverificaControl.text) {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return alertaDialog(
                          titulo: 'Erro!',
                          msgerro: _passwordControl.text.isEmpty
                              ? 'Introduza uma password.'
                              : _passwordControl.text.length < 6
                                  ? 'A password tem que ter mais de 6 caractéres.'
                                  : _passwordControl.text !=
                                          _passverificaControl.text
                                      ? 'As passwords não coincidem.'
                                      : _passwordControl.text,
                          onPress: () {
                            _passwordControl.clear();
                            _passverificaControl.clear();
                            Navigator.pop(context);
                          },
                        );
                      },
                      barrierDismissible: true,
                    );
                  } else {
                    setState(() {
                      showSpinner = true;
                    });

                    var mostrar = await ServicosFirebaseAuth()
                        .registarEmailPassword(context, utilizador.email,
                            utilizador.password, showSpinner);

                    ServicosFirestoreDatabase().criarUtilizador(
                        utilizador.nome, utilizador.email, context);
                  }
                  setState(() {
                    showSpinner = false;
                  });
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
