import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

class PhotosRepositoryMock extends Mock implements PhotosRepository {}

void main() {
  group('PhotosCubitTest -', () {
    PhotosRepositoryMock photosRepository;

    final userId = 'absada1';
    final exceptionMessage = 'An exception occured';

    setUp(() {
      photosRepository = PhotosRepositoryMock();
    });

    group('getMultiplePhotosUrls -', () {
      blocTest(
        'When successful, emits [PhotosWaiting, PhotosMultipleFetched]',
        build: () {
          when(photosRepository.getPhotosUrlsForUser(any)).thenAnswer(
              (_) async => ['photoUrl_1', 'photoUrl_2', 'photoUrl_3']);
          return PhotosCubit(photosRepository);
        },
        act: (cubit) => cubit.getMultiplePhotosUrls(userId),
        expect: [
          PhotosWaiting(),
          PhotosMultipleFetched(['photoUrl_1', 'photoUrl_2', 'photoUrl_3']),
        ],
      );
      blocTest(
        'When failure, emits [PhotosWaiting, PhotosFailureFetching]',
        build: () {
          when(photosRepository.getPhotosUrlsForUser(any)).thenThrow(
              FirebaseException(plugin: 'plugin', message: exceptionMessage));
          return PhotosCubit(photosRepository);
        },
        act: (cubit) => cubit.getMultiplePhotosUrls(userId),
        expect: [
          PhotosWaiting(),
          PhotosFailureFetching(message: exceptionMessage),
        ],
      );
    });
    group('uploadPhoto -', () {
      final photo = PickedFile('photoPath');
      blocTest(
        'When successful, emits [PhotosWaiting, PhotosSingleUploaded]',
        build: () {
          when(photosRepository.uploadPhoto(any, any))
              .thenAnswer((_) async => null);
          return PhotosCubit(photosRepository);
        },
        act: (cubit) => cubit.uploadPhoto(userId, photo),
        expect: [
          PhotosWaiting(),
          PhotosSingleUploaded(),
        ],
      );
      blocTest(
        'When failure, emits [PhotosWaiting, PhotosFailureSending]',
        build: () {
          when(photosRepository.uploadPhoto(any, any)).thenThrow(
              FirebaseException(plugin: 'plugin', message: exceptionMessage));
          return PhotosCubit(photosRepository);
        },
        act: (cubit) => cubit.uploadPhoto(userId, photo),
        expect: [
          PhotosWaiting(),
          PhotosFailureSending(message: exceptionMessage),
        ],
      );
    });
    group('deletePhotoByUrl -', () {
      final initialPhotosUrls = [
        'photoUrl_1',
        'photoUrl_2',
        'photoUrl_3',
      ];
      final remainingPhotosUrls = [
        'photoUrl_2',
        'photoUrl_3',
      ];

      blocTest(
          'When successful, emits [PhotosWaiting, PhotosMultipleFetched(updatedPhotosList)]',
          build: () {
            when(photosRepository.deletePhotoByUrl(any))
                .thenAnswer((_) async => null);
            return PhotosCubit(photosRepository);
          },
          act: (cubit) =>
              cubit.deletePhotoByUrl('photoUrl_1', initialPhotosUrls),
          expect: [
            PhotosWaiting(),
            PhotosMultipleFetched(remainingPhotosUrls),
          ]);
      blocTest(
          'When failure, emits [PhotosWaiting, PhotosFailureDeleting, PhotosMultipleFetched(oldPhotosList)]',
          build: () {
            when(photosRepository.deletePhotoByUrl(any)).thenThrow(
                FirebaseException(plugin: 'plugin', message: exceptionMessage));
            return PhotosCubit(photosRepository);
          },
          act: (cubit) =>
              cubit.deletePhotoByUrl('photoUrl_1', initialPhotosUrls),
          expect: [
            PhotosWaiting(),
            PhotosFailureDeleting(message: 'Could not delete photo.'),
            PhotosMultipleFetched(initialPhotosUrls),
          ]);
    });
  });
}
