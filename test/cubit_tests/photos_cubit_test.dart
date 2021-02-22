import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

class PhotosRepositoryMock extends Mock implements PhotosRepository {}

void main() {
  group('PhotosCubitTest -', () {
    PhotosRepositoryMock photosRepository;

    final userId = 'absada1';

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
        'When failure, emits [PhotosWaiting, PhotosError]',
        build: () {
          when(photosRepository.getPhotosUrlsForUser(any))
              .thenThrow(ErrorDescription('An error occured'));
          return PhotosCubit(photosRepository);
        },
        act: (cubit) => cubit.getMultiplePhotosUrls(userId),
        expect: [
          PhotosWaiting(),
          PhotosError(),
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
        'When failure, emits [PhotosWaiting, PhotosSingleUploaded]',
        build: () {
          when(photosRepository.uploadPhoto(any, any))
              .thenThrow(ErrorDescription('An error occured'));
          return PhotosCubit(photosRepository);
        },
        act: (cubit) => cubit.uploadPhoto(userId, photo),
        expect: [
          PhotosWaiting(),
          PhotosError(),
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
          'When failure, emits [PhotosWaiting, PhotosError, PhotosMultipleFetched(oldPhotosList)]',
          build: () {
            when(photosRepository.deletePhotoByUrl(any))
                .thenThrow(Exception('An error occured'));
            return PhotosCubit(photosRepository);
          },
          act: (cubit) =>
              cubit.deletePhotoByUrl('photoUrl_1', initialPhotosUrls),
          expect: [
            PhotosWaiting(),
            PhotosError(message: 'Could not delete photo.'),
            PhotosMultipleFetched(initialPhotosUrls),
          ]);
    });
  });
}
