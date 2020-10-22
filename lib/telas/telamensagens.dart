import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:chatme/networking/servicos_firebase_auth.dart';
import 'package:chatme/networking/servicos_firestore_database.dart';
import 'package:chatme/telas/telahome.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TelaMensagens extends StatefulWidget {
  static const String id = 'tela_mensagens';
  @override
  _TelaMensagensState createState() => _TelaMensagensState();
}

class _TelaMensagensState extends State<TelaMensagens> {
  Map dados = {};
  String _userEmail, _utilizador;

  emailRemetente() async {
    _utilizador = await ServicosFirebaseAuth().obterUtilizador();
    setState(() {
      _userEmail = _utilizador;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailRemetente();
  }

  @override
  Widget build(BuildContext context) {
    dados = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            customAppbar(
              userEmail: _userEmail,
              iconePrefixo: Icons.arrow_back_ios,
              titulo: dados['nome'],
              iconeSufixo: FontAwesomeIcons.phoneAlt,
              onTapp: () {
                Navigator.pushReplacementNamed(context, TelaHome.id)
                    .then((value) => setState(() => {}));
              },
            ),
            SizedBox(
              height: 2.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.vertical,
                child: ServicosFirestoreDatabase().streamBuilder(
                  contexto: context,
                  utilizador: _userEmail,
                ),
              ),
            ),
            textfieldFlutuante(context: context, useremail: _userEmail),
          ],
        ),
      ),
    );
  }
}
