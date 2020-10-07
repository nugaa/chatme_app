import 'package:chatme/networking/firebase_storage.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('images/foto.jpg'),
                          radius: 50.0,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.plusCircle,
                    color: Colors.white30,
                  ),
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    PickedFile _imagemSelecionada;
                    //TODO: adicionar imagem
                    final imagem =
                        await _picker.getImage(source: ImageSource.gallery);
                    _imagemSelecionada = imagem;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
