import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class PhotosRepositoryMock extends Mock implements PhotosRepository {}

void main() {
  group('PhotosCubitTest -', () {
    PhotosRepositoryMock photosRepository;

    setUp(() {
      photosRepository = PhotosRepositoryMock();
    });

    group('getMultiplePhotosUrls -', () {
      final userId = 'absada1';
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
  });
}
