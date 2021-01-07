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
  String _salaNome, _meuUsername;

  nomeDaSala() async {
    _meuUsername = await ServicosFirestoreDatabase().getMeuUsername(_userEmail);
    _salaNome = await ServicosFirestoreDatabase()
        .verificarSalaExiste(enviadoPor: _meuUsername, destino: dados['nome']);
    setState(() {});
  }

  emailRemetente() async {
    _utilizador = await ServicosFirebaseAuth().obterUtilizador();
    setState(() {
      _userEmail = _utilizador;
    });
    await nomeDaSala();
  }

  @override
  void initState() {
    emailRemetente();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dados = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            customAppbar(
              imagemAvatar: dados['avatar'],
              userEmail: _userEmail,
              iconePrefixo: Icons.arrow_back_ios,
              titulo: dados['nome'],
              iconeSufixo: FontAwesomeIcons.phoneAlt,
              onTapp: () {
                ServicosFirestoreDatabase()
                    .apagarSalaChat(_meuUsername, dados['nome']);
                Navigator.pushReplacementNamed(context, TelaHome.id);
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
                  nomeSala: _salaNome,
                ),
              ),
            ),
            textfieldFlutuante(
              context: context,
              useremail: _userEmail,
              destinatario: dados['nome'],
            ),
          ],
        ),
      ),
    );
  }
}
