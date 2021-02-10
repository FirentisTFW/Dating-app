import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'photos_state.dart';

class PhotosCubit extends Cubit<PhotosState> {
  final PhotosRepository _photosRepository;

  PhotosCubit(this._photosRepository) : super(PhotosInitial());

  Future<void> getSinglePhotoUrl(String userId, String photoName) async {
    emit(PhotosWaiting());

    try {
      final photoUrl = await _photosRepository.getPhotoUrl(userId, photoName);
      emit(PhotosSingleFetched(photoUrl));
    } catch (err) {
      emit(PhotosError());
    }
  }

  Future<void> getMultiplePhotosUrls(
      String userId, List<String> photoNames) async {
    emit(PhotosWaiting());

    try {
      List<String> photosUrls = [];
      for (int i = 0; i < photoNames.length; i++) {
        final url = await _photosRepository.getPhotoUrl(userId, photoNames[i]);
        photosUrls.add(url);
      }
      emit(PhotosMultipleFetched(photosUrls));
    } catch (err) {
      emit(PhotosError());
    }
  }

  Future<bool> uploadPhoto(String userId, PickedFile photo) async {
    emit(PhotosWaiting());

    try {
      await _photosRepository.uploadPhoto(photo, userId);
      emit(PhotosSingleUploaded());
      return true;
    } catch (err) {
      emit(PhotosError());
      return false;
    }
  }
}
