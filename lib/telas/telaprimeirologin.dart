import 'dart:io';
import 'package:chatme/customwidgets/textstylescustom.dart';
import 'package:chatme/networking/firebase_storage.dart';
import 'package:chatme/networking/servicos_firebase_auth.dart';
import 'package:chatme/telas/telahome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class TelaPrimeiroLogin extends StatefulWidget {
  static const String id = 'tela_primeiro_login';
  @override
  _TelaPrimeiroLoginState createState() => _TelaPrimeiroLoginState();
}

class _TelaPrimeiroLoginState extends State<TelaPrimeiroLogin> {
  String _userEmail, _utilizador;
  File _imagemSelecionada;

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
                          padding: const EdgeInsets.all(20.0),
                          child: CircleAvatar(
                            backgroundImage: _imagemSelecionada == null
                                ? AssetImage('images/foto.png')
                                : FileImage(_imagemSelecionada),
                            radius: 50.0,
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
                _imagemSelecionada != null
                    ? IconButton(
                        iconSize: 40.0,
                        icon: FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.white30,
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, TelaHome.id);
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
