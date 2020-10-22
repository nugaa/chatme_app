import 'package:chatme/constantes.dart';
import 'package:chatme/customwidgets/alertcustom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:intl/intl.dart';

class ServicosFirestoreDatabase {
  final _firestore = FirebaseFirestore.instance;

  Future<String> getUsernameDestino(String email) async {
    String nomeDestino;
    final documento = await _firestore.collection('Utilizador').doc().get();

    nomeDestino = documento.data()['username'];
    print(nomeDestino);
  }

  Future<String> getMeuUsername(String email) async {
    String meuNome;
    final documento =
        await _firestore.collection('Utilizador').doc(email).get();

    meuNome = documento.data()['username'];
    return meuNome;
  }

  Future criarUsername(BuildContext contexto, String username, String email,
      TextEditingController chave) async {
    List listaUsernames = [];
    final documento =
        await _firestore.collection('Utilizador').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        listaUsernames.add(doc.get('username'));
      });
    });
    if (listaUsernames.contains(username)) {
      return showDialog(
        context: contexto,
        builder: (_) {
          return alertaDialog(
            titulo: 'Erro!',
            msgerro: 'O username que introduziu já está a ser utilizado.',
            onPress: () {
              chave.clear();
              Navigator.pop(contexto);
            },
          );
        },
        barrierDismissible: true,
      );
    } else {
      _firestore.collection('Utilizador').doc(email).update(
        {
          'username': username,
        },
      );
    }
  }

  Future criarUtilizador(
      String nome, String email, BuildContext contexto) async {
    List listaDocs = [];
    final documentId =
        await _firestore.collection('Utilizador').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        listaDocs.add(doc.id);
      });
    });
    //TODO: verificar se username existe
    if (listaDocs.contains(email)) {
      return showDialog(
        context: contexto,
        builder: (_) {
          return alertaDialog(
            titulo: 'Erro!',
            msgerro: 'Já existe uma conta com este email.',
            onPress: () {
              Navigator.pop(contexto);
            },
          );
        },
        barrierDismissible: true,
      );
    } else {
      _firestore.collection('Utilizador').doc(email).set({
        'nome': nome,
        'email': email,
        'username': '',
      });
    }
  }

  Future enviarMensagem(String enviadoPor, String mensagem, String email) {
    DateTime agora = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String diaFormatado = formatter.format(agora);
    final DateFormat format = DateFormat.Hm();
    final String horaFormatada = format.format(agora);
    //PASSAR O NOME DA LISTA PARA AQUI!!!
    _firestore.collection('Mensagens').doc('$enviadoPor''_$').add({
      'enviadoPor': enviadoPor,
      'mensagem': mensagem,
      'email': email,
      'criadoEm': diaFormatado,
      'horas': horaFormatada,
      'diaHora': agora.toString(),
    });
  }

  Future<List<String>> obterDadosUltimaMensagem() async {
    try {
      QuerySnapshot query = await _firestore
          .collection('Mensagens')
          .orderBy('diaHora', descending: true)
          .limit(1)
          .get();

      if (query != null) {
        String ultimaMsg = query.docs.last.get('mensagem');
        String ultimaHora = query.docs.last.get('horas');

        if (ultimaMsg != null && ultimaHora != null) {
          return [ultimaMsg, ultimaHora];
        }
      } else {
        String semMsg = 'Não há mensagens para mostrar.';
        return [semMsg];
      }
    } on FirebaseException catch (e) {
      print('obterDadosUltimaMensagem deu um erro: $e');
    }
  }

  StreamBuilder streamBuilder({BuildContext contexto, String utilizador}) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Mensagens')
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
