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
      final photosNames = [
        'photo_1',
        'photo_2',
        'photo_3',
      ];
      blocTest(
        'When successful, emits [PhotosWaiting, PhotosMultipleFetched]',
        build: () {
          when(photosRepository.getPhotoUrl(any, any))
              .thenAnswer((_) async => 'photoUrl');
          return PhotosCubit(photosRepository);
        },
        act: (cubit) => cubit.getMultiplePhotosUrls(userId, photosNames),
        expect: [
          PhotosWaiting(),
          PhotosMultipleFetched(['photoUrl', 'photoUrl', 'photoUrl']),
        ],
      );
      blocTest(
        'When failure, emits [PhotosWaiting, PhotosError]',
        build: () {
          when(photosRepository.getPhotoUrl(any, any))
              .thenThrow(ErrorDescription('An error occured'));
          return PhotosCubit(photosRepository);
        },
        act: (cubit) => cubit.getMultiplePhotosUrls(userId, photosNames),
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
  });
}
