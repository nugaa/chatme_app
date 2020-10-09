import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageRepo {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://chatme-a5cb8.appspot.com/');
  final picker = ImagePicker();

  Future uploadUserAvatar(
      BuildContext contexto, File imageFile, String userEmail) async {
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
        print(e.code);
      }
    }
  }

  Future<Widget> obterUserAvatar({String user, double diametro}) async {
    String m;
    CircleAvatar circleAvatar;
    await _storage
        .ref()
        .child('uploads/$user/avatars/avatar')
        .getDownloadURL()
        .then((downloadUrl) {
      m = downloadUrl.toString();
    });

    circleAvatar = CircleAvatar(
      backgroundImage: NetworkImage(m),
      radius: diametro,
    );
    return circleAvatar;
  }
}
