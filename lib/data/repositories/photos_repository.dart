import 'dart:io';

import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/data_providers/firebase_storage_provider.dart';
import 'package:image_picker/image_picker.dart';

class PhotosRepository {
  final _storageProvider = locator<FirebaseStorageProvider>();

  Future uploadPhoto(PickedFile photo, String userId) async {
    final photoFile = File(photo.path);
    final photoName = DateTime.now().millisecondsSinceEpoch.toString();
    await _storageProvider.uploadPhoto(photoFile, photoName, userId);
  }

  Future getPhotoUrl(String userId, String photoName) async =>
      await _storageProvider.getPhotoUrl(userId, photoName);

  Future<List<String>> getPhotosUrlsForUser(String userId) async =>
      await _storageProvider.getPhotosUrlsForUser(userId);

  Future<String> getFirstPhotoUrlForUser(String userId) async =>
      await _storageProvider.getFirstPhotoUrlForUser(userId);

  Future<void> deletePhotoByUrl(String photoUrl) async =>
      await _storageProvider.deletePhotoByUrl(photoUrl);
}
