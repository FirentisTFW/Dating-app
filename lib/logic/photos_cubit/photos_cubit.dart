import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'photos_state.dart';

class PhotosCubit extends Cubit<PhotosState> {
  final PhotosRepository _photosRepository;

  PhotosCubit(this._photosRepository) : super(PhotosInitial());

  Future<void> getMultiplePhotosUrls(String userId) async {
    emit(PhotosWaiting());

    try {
      final photosUrls = await _photosRepository.getPhotosUrlsForUser(userId);
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

  Future<void> deletePhotoByUrl(
      String deletingPhotoUrl, List<String> photosUrls) async {
    emit(PhotosWaiting());

    try {
      await _photosRepository.deletePhotoByUrl(deletingPhotoUrl);
      photosUrls.remove(deletingPhotoUrl);
      emit(PhotosMultipleFetched(photosUrls));
    } catch (err) {
      emit(PhotosError(message: 'Could not delete photo.'));
      emit(PhotosMultipleFetched(photosUrls));
    }
  }
}
