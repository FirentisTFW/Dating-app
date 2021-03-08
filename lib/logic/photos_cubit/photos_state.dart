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

  const PhotosSingleFetched(this.photoUrl);

  @override
  List<Object> get props => [photoUrl];
}

class PhotosMultipleFetched extends PhotosState {
  final List<String> photosUrls;

  const PhotosMultipleFetched(this.photosUrls);

  @override
  List<Object> get props => [photosUrls];
}

abstract class PhotosFailure extends PhotosState {
  final String message;

  const PhotosFailure({this.message});

  @override
  List<Object> get props => [message];
}

class PhotosFailureFetching extends PhotosFailure {
  const PhotosFailureFetching({message}) : super(message: message);
}

class PhotosFailureSending extends PhotosFailure {
  const PhotosFailureSending({message}) : super(message: message);
}

class PhotosFailureDeleting extends PhotosFailure {
  const PhotosFailureDeleting({message}) : super(message: message);
}
