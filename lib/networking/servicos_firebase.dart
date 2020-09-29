import 'package:chatme/telas/telamensagens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatme/telas/telaprimeirologin.dart';

class ServicosFirebase {
  final _auth = FirebaseAuth.instance;

  Future registarEmailPassword(
      BuildContext context, String email, String password, bool mostrar) async {
    try {
      final novoUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushReplacementNamed(context, TelaPrimeiroLogin.id);
      if (mostrar == true) {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future loginEmailPassword(
      BuildContext context, String email, String password, bool mostrar) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushNamed(context, TelaMensagens.id);
      if (mostrar == true) {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //TODO: se der erro mostrar widget com mensagem de erro
        print('Não existe nenhum utilizador com este email.');
      } else if (e.code == 'wrong-password') {
        print('A password está errada para este email.');
      }
    }
  }

  void obterUtilizador() async {
    final _auth = FirebaseAuth.instance;
    User userLogado;
    try {
      final user = await _auth.currentUser;

      if (user != null) {
        userLogado = user;
        print(userLogado.email);
      }
    } catch (e) {
      print(e.message);
    }
  }
}
