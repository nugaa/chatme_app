import 'package:chatme/customwidgets/alertcustom.dart';
import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:chatme/customwidgets/textstylescustom.dart';
import 'package:chatme/networking/google_service.dart';
import 'package:chatme/networking/servicos_firebase_auth.dart';
import 'package:chatme/telas/telaregisto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constantes.dart';

class TelaLogin extends StatefulWidget {
  static const String id = 'tela_login';

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  String email;
  String password;
  bool showSpinner = false;

  TextEditingController emailEditingText = TextEditingController();
  TextEditingController passwordEditingText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(
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
                      control: emailEditingText,
                      padHorizontal: 16.0,
                      padVertical: 16.0,
                      esconderTexto: false,
                      icone: Icons.person_outline,
                      textoHint: 'Introduza o seu email',
                      textInput: TextInputType.emailAddress,
                      onChange: (value) {
                        email = value;
                      },
                    ),
                    textFieldCustom(
                      control: passwordEditingText,
                      padHorizontal: 16.0,
                      padVertical: 16.0,
                      esconderTexto: true,
                      icone: Icons.lock_outline,
                      textoHint: 'Introduza a sua password',
                      onChange: (value) {
                        password = value;
                      },
                    ),
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
                            onPressed: () async {
                              if (emailEditingText.text.isNotEmpty &&
                                  passwordEditingText.text.isNotEmpty) {
                                setState(() {
                                  showSpinner = true;
                                });

                                var passarFalso = await ServicosFirebaseAuth()
                                    .loginEmailPassword(
                                        context, email, password, showSpinner);

                                setState(() {
                                  showSpinner = passarFalso;
                                });

                                emailEditingText.clear();
                                passwordEditingText.clear();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return alertaDialog(
                                      titulo: 'Erro!',
                                      msgerro:
                                          'Por favor preencha todos os campos.',
                                      onPress: () {
                                        emailEditingText.clear();
                                        passwordEditingText.clear();
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                  barrierDismissible: true,
                                );
                              }
                            }),
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
                    separador,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        customIconButton(
                          icone: FontAwesomeIcons.google,
                          cor: corBotao,
                          tamanho: 30.0,
                          onPress: () {
                            setState(() {
                              showSpinner = true;
                            });
                            signInWithGoogle(context);

                            if (showSpinner == true) {
                              setState(() {
                                showSpinner = false;
                              });
                            }
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
