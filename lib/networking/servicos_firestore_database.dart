import 'package:chatme/constantes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatme/customwidgets/customWidgets.dart';

class ServicosFirestoreDatabase {
  final _firestore = FirebaseFirestore.instance;

  Future enviarMensagem(
      String enviadoPor, String mensagem, String email) async {
    _firestore.collection('mensagens').add({
      'enviadoPor': enviadoPor,
      'mensagem': mensagem,
      'email': email,
    });
  }

  Future obterMensagens() async {
    await for (var snapshot in _firestore.collection('mensagens').snapshots()) {
      for (var mensagem in snapshot.docs) {}
    }
  }

  StreamBuilder streamBuilder({BuildContext contexto, String utilizador}) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('mensagens').snapshots(),
      builder: (context, mensagem) {
        if (!mensagem.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: corBotao,
            ),
          );
        }
        final mensagens = mensagem.data.docs.reversed;
        List<Widget> msgWidgets = [];
        for (var msg in mensagens) {
          final msgTexto = msg.data()['mensagem'];
          final msgEnviadoPor = msg.data()['enviadoPor'];
          final emailUser = msg.data()['email'];
          Container msgWidget = salaChatCard(
            context: contexto,
            enviadoPorMim: emailUser == utilizador ? true : false,
            imagemUrl: null,
            textoMensagem: msgTexto,
            remetente: msgEnviadoPor,
          );
          msgWidgets.add(msgWidget);
        }
        return Column(
          children: msgWidgets,
        );
      },
    );
  }
}
