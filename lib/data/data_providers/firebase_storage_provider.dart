import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageProvider {
  final _storage = FirebaseStorage.instance;

  Future uploadPhoto(File photo, String photoName, String userId) async {
    final storagePath =
        _storage.ref().child('users_images').child(userId).child(photoName);
    await storagePath.putFile(photo);
  }
}
