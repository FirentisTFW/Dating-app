import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:Dating_app/presentation/helpers/photos_cubit_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/main_view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import 'components/photo_item.dart';

// ignore: must_be_immutable
class MyPhotosView extends StatelessWidget {
  List<PickedFile> _pickedImages = [];

  MyPhotosView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: [
          BlocConsumer<PhotosCubit, PhotosState>(
            listener: (context, state) {
              if (state is PhotosSingleUploaded && _pickedImages.length == 0) {
                goToMainView();
              }
              if (state is PhotosError) {
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
                      goToMainView();
                    }
                  },
                  child: const Text(
                    'Next',
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhotosRow(addImage),
            const Expanded(child: SizedBox()),
            PhotosRow(addImage),
            const Expanded(child: SizedBox()),
            PhotosRow(addImage),
          ],
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

  void goToMainView() => Get.off(MainView());

  void addImage(PickedFile image) => _pickedImages.add(image);

  Future<void> uploadPhotos(BuildContext context) async {
    final currentState = BlocProvider.of<CurrentUserCubit>(context).state
        as CurrentUserWithUserInstance;
    final userId = currentState.user.id;

    while (_pickedImages.length > 0) {
      final wasPhotoUploaded = await BlocProvider.of<PhotosCubit>(context)
          .uploadPhoto(userId, _pickedImages.first);

      if (wasPhotoUploaded) {
        _pickedImages.removeAt(0);
      } else {
        break;
      }
    }
  }
}

class PhotosRow extends StatelessWidget {
  final Function addImage;

  const PhotosRow(this.addImage, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          PhotoItem(addImage),
          const Expanded(child: SizedBox()),
          PhotoItem(addImage),
          const Expanded(child: SizedBox()),
          PhotoItem(addImage),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
