import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/presentation/helpers/photos_cubit_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/main_view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import 'components/photos_row.dart';

// ignore: must_be_immutable
class MyPhotosView extends StatelessWidget {
  final bool firstTime;

  List<PickedFile> _pickedImages = [];
  List<String> _currentImages = [];

  MyPhotosView({Key key, this.firstTime = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _fetchUserCurrentPhotos(context);

    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: [
          BlocConsumer<PhotosCubit, PhotosState>(
            listener: (context, state) {
              if (state is PhotosSingleUploaded && _pickedImages.length == 0) {
                firstTime ? goToMainView() : Get.back();
              } else if (state is PhotosMultipleFetched) {
                _currentImages = state.photosUrls;
              } else if (state is PhotosFailure) {
                PhotosCubitHelpers.showErrorSnackbar(state);
              }
            },
            builder: (context, state) {
              if (state is PhotosWaiting) {
                return _loadingSpinner;
              } else {
                return FlatButton(
                  padding: const EdgeInsets.only(right: 10),
                  onPressed: () async {
                    if (_pickedImages.length > 0) {
                      await uploadPhotos(context);
                    } else {
                      firstTime ? goToMainView() : Get.back();
                    }
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: BlocBuilder<PhotosCubit, PhotosState>(
          builder: (context, state) {
            if (state is PhotosWaiting) {
              return LoadingSpinner();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildPhotosRows(),
            );
          },
        ),
      ),
    );
  }

  final _appBarTitle = const Padding(
    padding: EdgeInsets.only(left: 20),
    child: Text(
      'Add photos',
      style: TextStyle(
          color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
    ),
  );

  final _loadingSpinner = const Padding(
    padding: EdgeInsets.only(right: 20),
    child: LoadingSpinner(
      color: Colors.white,
    ),
  );

  List<Widget> _buildPhotosRows() {
    List<Widget> rows = [];

    for (int i = 0; i < 3; i++) {
      List<String> initialPhotosUrls = [];
      for (int j = i * 3; j < _currentImages.length; j++) {
        initialPhotosUrls.add(_currentImages[j]);
      }

      rows.add(
        PhotosRow(
          addImage,
          removeOldImage: removeOldImage,
          initialPhotosUrls: initialPhotosUrls,
        ),
      );

      if (i != 2) {
        rows.add(const Expanded(child: SizedBox()));
      }
    }

    return rows;
  }

  void _fetchUserCurrentPhotos(BuildContext context) {
    final userData = locator<CurrentUserData>();

    if (userData.isUserSet) {
      BlocProvider.of<PhotosCubit>(context)
          .getMultiplePhotosUrls(userData.userId);
    }
  }

  void goToMainView() => Get.off(MainView());

  void addImage(PickedFile image) => _pickedImages.add(image);

  void removeOldImage(BuildContext context, String photoUrl) =>
      BlocProvider.of<PhotosCubit>(context)
          .deletePhotoByUrl(photoUrl, _currentImages);

  Future<void> uploadPhotos(BuildContext context) async {
    final userData = locator<CurrentUserData>();

    if (userData.isUserSet) {
      while (_pickedImages.length > 0) {
        final wasPhotoUploaded = await BlocProvider.of<PhotosCubit>(context)
            .uploadPhoto(userData.userId, _pickedImages.first);

        if (wasPhotoUploaded) {
          _pickedImages.removeAt(0);
        } else {
          break;
        }
      }
    }
  }
}
