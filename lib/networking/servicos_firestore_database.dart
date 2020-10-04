import 'package:chatme/constantes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:intl/intl.dart';

class ServicosFirestoreDatabase {
  final _firestore = FirebaseFirestore.instance;

  Future enviarMensagem(
      String enviadoPor, String mensagem, String email) async {
    DateTime agora = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String diaFormatado = formatter.format(agora);
    final DateFormat format = DateFormat.Hm();
    final String horaFormatada = format.format(agora);
    _firestore.collection('mensagens').add({
      'enviadoPor': enviadoPor,
      'mensagem': mensagem,
      'email': email,
      'criadoEm': diaFormatado,
      'horas': horaFormatada,
      'diaHora': agora.toString(),
    });
  }

  Future obterMensagens() async {
    await for (var snapshot in _firestore.collection('mensagens').snapshots()) {
      for (var mensagem in snapshot.docs) {}
    }
  }

  StreamBuilder streamBuilder({BuildContext contexto, String utilizador}) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('mensagens')
          .orderBy('diaHora', descending: true)
          .snapshots(),
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
          final hora = msg.data()['horas'];
          Container msgWidget = salaChatCard(
            context: contexto,
            enviadoPorMim: emailUser == utilizador ? true : false,
            imagemUrl: null,
            textoMensagem: msgTexto,
            horas: hora == hora ? hora : '',
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
