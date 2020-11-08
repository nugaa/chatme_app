import 'dart:io';
import 'package:chatme/customwidgets/customWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageRepo {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://chatme-a5cb8.appspot.com/');
  final picker = ImagePicker();

  Future uploadUserAvatar(
    BuildContext contexto,
    File imageFile,
    String userEmail,
  ) async {
    if (userEmail != null) {
      try {
        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('uploads/$userEmail/avatars/avatar');
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        taskSnapshot.ref.getDownloadURL().then(
              (value) => print('Completo: $value'),
            );
      } on FirebaseException catch (e) {
        print('Erro em uploadUserAvatar(): ${e.code}');
      }
    }
  }

  Future obterUserAvatar({String user, double diametro}) async {
    String m;
    CircleAvatar circleAvatar;

    if (user != null) {
      try {
        await _storage
            .ref()
            .child('uploads/$user/avatars/avatar')
            .getDownloadURL()
            .then((downloadUrl) {
          m = downloadUrl.toString();
        });

        circleAvatar = CircleAvatar(
          backgroundImage: NetworkImage(m),
          radius: diametro == null ? diametro = 28.0 : diametro,
        );
        return circleAvatar;
      } on FirebaseException catch (e) {
        print('Erro em obterUserAvatar(): ${e.code}');
      }
    } else {
      return Container();
    }
  }

  Future<ListView> todosAvatares(
      {@required BuildContext ctx,
      double diametro,
      String email,
      String mUsername}) async {
    String m;
    final _firestore = FirebaseFirestore.instance;
    List listaEmails = [];
    List listaUsername = [];
    List<Widget> listaAvatars = [];
    try {
      final documento =
          await _firestore.collection('Utilizador').get().then((snapshot) {
        snapshot.docs.forEach((doc) {
          listaEmails.add(doc.get('email'));
          listaEmails.removeWhere((item) => item == email);
        });
      });

      final docUsername = _firestore
        ..collection('Utilizador').get().then((snapshot) {
          snapshot.docs.forEach((doc) {
            doc.id == email ? null : listaUsername.add(doc.get('username'));
          });
        });

      for (int i = 0; i < listaEmails.length; i++) {
        await _storage
            .ref()
            .child('uploads/${listaEmails[i]}/avatars/avatar')
            .getDownloadURL()
            .then((downloadUrl) {
          m = downloadUrl.toString();
        });
        listaAvatars.add(
          CircleAvatar(
            backgroundImage: NetworkImage(m),
            radius: diametro == null ? diametro = 28.0 : diametro,
          ),
        );
      }
      return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: listaAvatars.length,
          itemBuilder: (BuildContext _, int index) {
            return Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  children: <Widget>[
                    contactoAvatar(
                      contexto: ctx,
                      avatar: listaAvatars[index],
                      nomeDestino: listaUsername[index],
                      meuUsername: mUsername,
                    ),
                  ],
                ));
          });
    } on FirebaseException catch (e) {
      print('Erro ao obter avatares para preencher lista: $e}');
    }
  }
}
