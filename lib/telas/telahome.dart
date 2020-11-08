import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:chatme/customwidgets/textstylescustom.dart';
import 'package:chatme/networking/firebase_storage_repo.dart';
import 'package:chatme/networking/servicos_firebase_auth.dart';
import 'package:chatme/networking/servicos_firestore_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TelaHome extends StatefulWidget {
  static const String id = 'tela_home';

  @override
  _TelaHomeState createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  //TODO: Na mensagemCard reparar Imagem e Nome apresentado.
  String nome = 'Teste';
  List<String> lista = [];
  String _userEmail, _utilizador;
  String username;

  obterMeuUsername(String email) async {
    username = await ServicosFirestoreDatabase().getMeuUsername(email);
  }

  preencherListaDados() async {
    try {
      List list = await ServicosFirestoreDatabase()
          .obterDadosUltimaMensagem('bakugou-wantek');

      if (list.isNotEmpty) {
        if (list != lista) {
          setState(() {
            lista = list;
          });
        } else {
          print('Não há novos items na lista.');
        }
      }
    } catch (e) {
      print('Erro em preencherListaDados(): $e');
    }
  }

  emailUser() async {
    try {
      _utilizador = await ServicosFirebaseAuth().obterUtilizador();
      setState(() {
        _userEmail = _utilizador;
      });
      await obterMeuUsername(_userEmail);
      await preencherListaDados();
    } catch (e) {
      print('Deu erro no emailUser: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    emailUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            customAppbar(
              userEmail: _userEmail,
              titulo: 'Minhas Mensagens',
              iconeSufixo: FontAwesomeIcons.bars,
              onTap2: () => ServicosFirebaseAuth().logout(context),
            ),
            SizedBox(
              height: 20.0,
            ),
            _barraPesquisa,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Contactos',
                    style: textFieldStyle(
                      tamanho: 20.0,
                      fontWeight: FontWeight.bold,
                      cor: Colors.white,
                    ),
                  ),
                  customIconButton(
                    cor: Colors.white,
                    icone: Icons.more_horiz,
                    tamanho: 35.0,
                    onPress: () async {
                      //TODO: onPress MOSTRAR TODOS CONTACTOS NUMA LISTA
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 100.0,
                      child: FutureBuilder<Widget>(
                        future: FirebaseStorageRepo().todosAvatares(
                            ctx: context,
                            email: _userEmail,
                            mUsername: username),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done)
                            return ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      novoContacto,
                                      snapshot.data,
                                    ],
                                  ),
                                )
                              ],
                            );
                          else if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(
                              child: Container(
                                height: 28.0,
                                width: 28.0,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          return Container();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'Mensagens',
                    style: textFieldStyle(
                      tamanho: 20.0,
                      fontWeight: FontWeight.bold,
                      cor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                //TODO: criar uma lista de widgets se EXISTIR COLEÇÃO Conversa
                child: FutureBuilder(
                    future: ServicosFirestoreDatabase()
                        .listarSalasMensagensUtilizador(
                      contexto: context,
                      username: username,
                      listaDeDados: lista,
                    ),
                    builder: (ctx, sala) {
                      if (sala.connectionState == ConnectionState.done) {
                        return sala.data;
                        // sala.hasData
                        //   ? sala.data
                        //   : Text(
                        //       'Não existem mensagens...',
                        //       style: textFieldStyle(
                        //           tamanho: 18, cor: Colors.white30),
                        //     );
                      } else if (sala.connectionState ==
                          ConnectionState.waiting)
                        return Center(
                          child: Container(
                            height: 28.0,
                            width: 28.0,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      return Container();
                    }),
              ),
            ),
            SizedBox(
              height: 14.0,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _barraPesquisa = Padding(
  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
  child: TextField(
    style: textFieldStyle(
      tamanho: 16.0,
      fontWeight: FontWeight.normal,
      cor: Colors.white,
    ),
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      suffixIcon: customIconButton(
        cor: Colors.white,
        icone: Icons.search,
        tamanho: 30,
        onPress: () {
          //TODO: ONPRESS botao procurar textField
        },
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
  ),
);

// mensagemCard(
// context: context,
// imagemPath: 'images/foto.jpg',
// nome: nome,
// ultimaMsg: lista[0],
// horas: lista[1],
// )
