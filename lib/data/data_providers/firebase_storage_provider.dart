import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageProvider {
  final _storage = FirebaseStorage.instance;

  Future uploadPhoto(File photo, String userId) async {
    final photoName = DateTime.now().millisecondsSinceEpoch.toString();
    final _storagePath =
        _storage.ref().child('users_images').child(userId).child(photoName);

    await _storagePath.putFile(photo);
  }
}
