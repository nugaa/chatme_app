import 'package:chatme/telas/telahome.dart';
import 'package:chatme/telas/telaprimeirologin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

//TODO: falta adicionar os dados no Firestore
Future<UserCredential> signInWithGoogle(BuildContext context) async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential authCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (authCredential.additionalUserInfo.isNewUser) {
      Navigator.pushNamed(context, TelaPrimeiroLogin.id);
    } else {
      Navigator.pushNamed(context, TelaHome.id);
    }
    // Once signed in, return the UserCredential
    if (credential != null) {
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      print('Erro ao iniciar com conta Google. Crendencial é Nula.');
    }
  } catch (e) {
    print(e.message);
  }
}
