import 'package:chatme/customwidgets/alertcustom.dart';
import 'package:chatme/telas/telahome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatme/telas/telaprimeirologin.dart';

class ServicosFirebaseAuth {
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return showDialog(
          context: context,
          builder: (_) {
            return alertaDialog(
              titulo: 'Erro!',
              msgerro: 'Este email já está ocupado.',
              onPress: () {
                Navigator.pop(context);
              },
            );
          },
          barrierDismissible: true,
        );
      } else if (e.code == 'weak-password') {
        return showDialog(
          context: context,
          builder: (_) {
            return alertaDialog(
              titulo: 'Erro!',
              msgerro: 'Password fraca, introduza uma password mais segura.',
              onPress: () {
                Navigator.pop(context);
              },
            );
          },
          barrierDismissible: true,
        );
      }
    }
  }

  // email-already-in-use
  //
  Future loginEmailPassword(
      BuildContext context, String email, String password, bool mostrar) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushNamed(context, TelaHome.id);
      if (mostrar == true) {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //TODO: se der erro mostrar widget com mensagem de erro
        return showDialog(
          context: context,
          builder: (_) {
            return alertaDialog(
              titulo: 'Erro!',
              msgerro: 'Não existe nenhum utilizador com este email.',
              onPress: () {
                Navigator.pop(context);
              },
            );
          },
          barrierDismissible: true,
        );
      } else if (e.code == 'wrong-password') {
        return showDialog(
          context: context,
          builder: (_) {
            return alertaDialog(
              titulo: 'Erro!',
              msgerro: 'A password está errada para este email.',
              onPress: () {
                Navigator.pop(context);
              },
            );
          },
          barrierDismissible: true,
        );
      }
    }
  }

  Future<String> obterUtilizador() async {
    User userLogado;
    String emailUser;
    try {
      final user = await _auth.currentUser;

      if (user != null) {
        userLogado = user;
        emailUser = userLogado.email;
      }
      return emailUser;
    } catch (e) {
      print(e.message);
    }
  }

  logout(BuildContext contexto) {
    _auth.signOut();
    Navigator.pop(contexto);
  }
}
