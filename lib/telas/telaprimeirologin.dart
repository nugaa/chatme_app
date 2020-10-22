import 'dart:io';
import 'package:chatme/customwidgets/alertcustom.dart';
import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:chatme/customwidgets/textstylescustom.dart';
import 'package:chatme/networking/firebase_storage.dart';
import 'package:chatme/networking/servicos_firebase_auth.dart';
import 'package:chatme/networking/servicos_firestore_database.dart';
import 'package:chatme/telas/telahome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../utilizador.dart';

class TelaPrimeiroLogin extends StatefulWidget {
  static const String id = 'tela_primeiro_login';
  @override
  _TelaPrimeiroLoginState createState() => _TelaPrimeiroLoginState();
}

class _TelaPrimeiroLoginState extends State<TelaPrimeiroLogin> {
  String _userEmail, _utilizador;
  File _imagemSelecionada;
  TextEditingController _usernameControl = TextEditingController();
  Utilizador utilizador = Utilizador();

  emailRemetente() async {
    _utilizador = await ServicosFirebaseAuth().obterUtilizador();
    setState(() {
      _userEmail = _utilizador;
    });
  }

  @override
  void initState() {
    super.initState();
    emailRemetente();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SafeArea(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            backgroundImage: _imagemSelecionada == null
                                ? AssetImage('images/foto.jpg')
                                : FileImage(_imagemSelecionada),
                            radius: 40.0,
                          )),
                    ),
                  ],
                ),
                Text(
                  'Adicione uma imagem ao seu avatar:',
                  style: textFieldStyle(
                    tamanho: 14,
                    cor: Colors.white30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.plusCircle,
                    color: Colors.white30,
                  ),
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final imagem =
                        await _picker.getImage(source: ImageSource.gallery);
                    setState(() {
                      _imagemSelecionada = File(imagem.path);
                    });

                    FirebaseStorageRepo().uploadUserAvatar(
                        context, _imagemSelecionada, _userEmail);
                  },
                ),
                textFieldCustom(
                  control: _usernameControl,
                  esconderTexto: false,
                  icone: Icons.tag_faces,
                  textoHint: 'Username',
                  onChange: (value) {
                    utilizador.username = value;
                  },
                ),
                _imagemSelecionada != null
                    ? IconButton(
                        iconSize: 40.0,
                        icon: FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.white30,
                        ),
                        onPressed: () {
                          if (_usernameControl.text.isEmpty ||
                              _usernameControl.text == null) {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return alertaDialog(
                                  titulo: 'Erro!',
                                  msgerro:
                                      'Introduza um username. Este nome será o que os outros irão ver.',
                                  onPress: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              barrierDismissible: true,
                            );
                          } else {
                            ServicosFirestoreDatabase().criarUsername(
                                context,
                                _usernameControl.text,
                                _userEmail,
                                _usernameControl);
                            Navigator.pushReplacementNamed(
                                context, TelaHome.id);
                          }
                        },
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
