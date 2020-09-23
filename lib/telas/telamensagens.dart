import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:chatme/customwidgets/textstylescustom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaMensagens extends StatefulWidget {
  static const String id = 'tela_mensagens';

  @override
  _TelaMensagensState createState() => _TelaMensagensState();
}

class _TelaMensagensState extends State<TelaMensagens> {
  List<Widget> listaUsers = [
    novoContacto,
    contactoAvatar(imagempath: 'images/foto.jpg', nome: 'Nuga'),
    contactoAvatar(imagempath: 'images/foto.jpg', nome: 'Nuga'),
    contactoAvatar(imagempath: 'images/foto.jpg', nome: 'Nuga'),
    contactoAvatar(imagempath: 'images/foto.jpg', nome: 'Nuga'),
    contactoAvatar(imagempath: 'images/foto.jpg', nome: 'Nuga'),
    contactoAvatar(imagempath: 'images/foto.jpg', nome: 'Nuga'),
    contactoAvatar(imagempath: 'images/foto.jpg', nome: 'Nuga'),
    contactoAvatar(imagempath: 'images/foto.jpg', nome: 'Nuga'),
    contactoAvatar(imagempath: 'images/foto.jpg', nome: 'Nuga'),
    contactoAvatar(imagempath: 'images/foto.jpg', nome: 'Nuga'),
    contactoAvatar(imagempath: 'images/foto.jpg', nome: 'Nuga'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: customAppbar(titulo: 'Minhas Mensagens'),
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
                    onPress: () {
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
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: listaUsers.length,
                        itemBuilder: (BuildContext _, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: listaUsers[index],
                          );
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
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: mensagemCard(
                imagemPath: 'images/foto.jpg',
                nome: 'Nuga',
                ultimaMsg: 'última mensagem',
                horas: '10:20',
              ),
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
    cursorColor: Colors.white,
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
    ),
  ),
);
