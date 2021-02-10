part of 'photos_cubit.dart';

abstract class PhotosState extends Equatable {
  const PhotosState();

  @override
  List<Object> get props => [];
}

class PhotosInitial extends PhotosState {}

class PhotosWaiting extends PhotosState {}

class PhotosSingleUploaded extends PhotosState {}

class PhotosSingleFetched extends PhotosState {
  final String photoUrl;

  PhotosSingleFetched(this.photoUrl);

  @override
  List<Object> get props => [photoUrl];
}

class PhotosMultipleFetched extends PhotosState {
  final List<String> photosUrls;

  PhotosMultipleFetched(this.photosUrls);

  @override
  List<Object> get props => [photosUrls];
}

class PhotosError extends PhotosState {
  final String message;

  PhotosError({this.message});

  @override
  List<Object> get props => [message];
}
