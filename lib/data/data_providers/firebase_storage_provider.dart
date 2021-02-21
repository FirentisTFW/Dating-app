import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageProvider {
  final _storage = FirebaseStorage.instance;

  Future uploadPhoto(File photo, String photoName, String userId) async {
    final storagePath =
        _storage.ref().child('users_images').child(userId).child(photoName);
    await storagePath.putFile(photo);
  }

  Future getPhotoUrl(String userId, String photoName) async => await _storage
      .ref()
      .child('users_images')
      .child(userId)
      .child(photoName)
      .getDownloadURL();

  Future<List<String>> getPhotosUrlsForUser(String userId) async {
    List<String> photosUrls = [];

    final allPhotosRef =
        await _storage.ref().child('users_images').child(userId).listAll();

    for (int i = 0; i < allPhotosRef.items.length; i++) {
      final url = await allPhotosRef.items[i].getDownloadURL();
      photosUrls.add(url);
    }

    return photosUrls;
  }

  Future<String> getFirstPhotoUrlForUser(String userId) async {
    final photoRef = await _storage
        .ref()
        .child('users_images')
        .child(userId)
        .list(ListOptions(maxResults: 1));

    return await photoRef.items.first.getDownloadURL();
  }

  Future<void> deletePhotoByUrl(String photoUrl) async {
    final ref = _storage.refFromURL(photoUrl);
    await ref.delete();
  }
}
