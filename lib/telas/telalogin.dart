import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:chatme/customwidgets/textstylescustom.dart';
import 'package:chatme/telas/telamensagens.dart';
import 'package:chatme/telas/telaregisto.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatefulWidget {
  static const String id = 'tela_login';

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Image.asset(
              'images/back_top.png',
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/back_bottom.png',
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    textFieldCustom(
                        padHorizontal: 16.0,
                        padVertical: 16.0,
                        esconderTexto: false,
                        icone: Icons.person_outline,
                        textoHint: 'Introduza o seu email',
                        textInput: TextInputType.emailAddress,
                        onChange: (value) {
                          email = value;
                        }),
                    textFieldCustom(
                        padHorizontal: 16.0,
                        padVertical: 16.0,
                        esconderTexto: true,
                        icone: Icons.lock_outline,
                        textoHint: 'Introduza a sua password',
                        onChange: (value) {
                          password = value;
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 6.0,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Text(
                              'Login',
                              style: textFieldStyle(tamanho: 16.0),
                            ),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, TelaMensagens.id),
                        ),
                        SizedBox(
                          width: 50.0,
                        ),
                        outlineButtonCustom(
                          texto: 'Registar',
                          onPress: () {
                            Navigator.pushNamed(context, TelaRegisto.id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
