import 'dart:async';
import 'package:chatme/constantes.dart';
import 'package:chatme/customwidgets/alertcustom.dart';
import 'package:chatme/networking/firebase_storage_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:intl/intl.dart';

class ServicosFirestoreDatabase {
  final _firestore = FirebaseFirestore.instance;

  Future obterUltimaMsgHora({
    List salas,
    String usernome,
  }) async {
    List listar = List();
    List listaDeDados = List();
    List listaFinal = List();

    for (var nomeSala in salas) {
      listar.add(nomeSala);

      if (nomeSala.toString().contains(usernome)) {
        listaDeDados = await obterDadosUltimaMensagem(nomeSala);

        for (int i = 0; i < listaDeDados.length; i++) {
          listaFinal.add(listaDeDados[i]);
        }
      }
    }
    return listaFinal;
  }

  Future<Widget> listarSalasMensagensUtilizador({
    BuildContext contexto,
    String username,
    List listaDeDados,
  }) async {
    String nomeDaSala;
    String idSala;
    List listaDeSalas = [];
    List listaDeNomes = [];
    List ultimaMsg = [];
    List ultimaHora = [];

    try {
      listaDeSalas = await salaMensagensId();

      if (listaDeSalas != null) {
        listaDeSalas.forEach(
          (item) async {
            if (item.contains(username)) {
              idSala = item;
              String removerMeuId = idSala.replaceAll('$username', '');
              nomeDaSala = removerMeuId.replaceAll('-', '');
              listaDeNomes.add(nomeDaSala);
            }
          },
        );
      }
      List listarUltimosDados = List();
      listarUltimosDados =
          await obterUltimaMsgHora(salas: listaDeSalas, usernome: username);

      for (int x = 0; x < listarUltimosDados.length;) {
        ultimaMsg.add(listarUltimosDados[x]);
        x = x + 2;
      }
      for (int i = 1; i < listarUltimosDados.length;) {
        ultimaHora.add(listarUltimosDados[i]);
        i = i + 2;
      }

      List listaDeEmails = List();
      List<Widget> listaDeAvatars = List();
      CircleAvatar cAvatar;
      for (var username in listaDeNomes) {
        final query = await _firestore
            .collection('Utilizador')
            .where('username', isEqualTo: username)
            .get();
        query.docs.forEach((element) {
          listaDeEmails.add(element.id);
        });
      }

      for (var email in listaDeEmails) {
        listaDeAvatars
            .add(await FirebaseStorageRepo().obterUserAvatar(user: email));
      }
      // cAvatar = await FirebaseStorageRepo().obterUserAvatar(user: nomeAvatar);
      return ListView.builder(
          shrinkWrap: true,
          itemCount: listaDeNomes.length,
          itemBuilder: (BuildContext _, int index) {
            return mensagemCard(
              nome: listaDeNomes[index],
              context: contexto,
              imagemAvatar: listaDeAvatars[index],
              ultimaMsg: ultimaMsg[index],
              horas: ultimaHora[index],
            );
          });
    } catch (e) {
      print(e);
    }
  }

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

  Future<List> salaMensagensId() async {
    String a;
    List _lista = []; //lista o id de todos os documentos das msgs entre users

    final QuerySnapshot query = await _firestore.collection('Mensagens').get();

    query.docs.forEach((doc) {
      if (doc.id != null) {
        a = doc.id;
      } else {
        print('Não tem mensagens.');
      }
      _lista.add(a);
    });
    return _lista;
  }

  Future<String> verificarSalaExiste(
      {String enviadoPor, String destino}) async {
    List _listaSalas = [];
    String _urlMsg;
    _listaSalas = await salaMensagensId();
    if (_listaSalas != null) {
      if (_listaSalas.contains('$enviadoPor-$destino')) {
        _urlMsg = '$enviadoPor-$destino';
      } else if (_listaSalas.contains('$destino-$enviadoPor')) {
        _urlMsg = '$destino-$enviadoPor';
      } else {
        _urlMsg = '$enviadoPor-$destino';
      }
    } else {
      print('Lista de salas vazia em obterSalas()');
    }
    return _urlMsg;
  }

  Future criarSalaChat(String mUser, String destino) async {
    String _salaNome;
    _salaNome = await verificarSalaExiste(enviadoPor: mUser, destino: destino);

    _firestore
        .collection('Mensagens')
        .doc(_salaNome)
        .set({'obj': 'sala de chat'});
  }

  Future enviarMensagem(
      String enviadoPor, String mensagem, String email, String destino) async {
    DateTime agora = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String diaFormatado = formatter.format(agora);
    final DateFormat format = DateFormat.Hm();
    final String horaFormatada = format.format(agora);
    String _nomeSala;
    _nomeSala =
        await verificarSalaExiste(enviadoPor: enviadoPor, destino: destino);

    if (_nomeSala != null) {
      _firestore
          .collection('Mensagens')
          .doc(_nomeSala)
          .collection('Conversa')
          .add({
        'enviadoPor': enviadoPor,
        'mensagem': mensagem,
        'email': email,
        'criadoEm': diaFormatado,
        'horas': horaFormatada,
        'diaHora': agora.toString(),
      });
    }
  }

  obterDadosUltimaMensagem(String nomeSala) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('Mensagens')
          .doc(nomeSala)
          .collection('Conversa')
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

  StreamBuilder streamBuilder({
    BuildContext contexto,
    String nomeSala,
    String utilizador,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Mensagens')
          .doc(nomeSala)
          .collection('Conversa')
          .orderBy('diaHora', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: corBotao,
            ),
          );
        }
        final mensagens = snapshot.data.docs.reversed;
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
