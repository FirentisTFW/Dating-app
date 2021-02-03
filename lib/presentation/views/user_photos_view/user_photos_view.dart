import 'dart:io';

import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class UserPhotosView extends StatelessWidget {
  List<PickedFile> _pickedImages = [];

  UserPhotosView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: [
          FlatButton(
            padding: const EdgeInsets.only(right: 10),
            onPressed: () => uploadPhotos(context),
            child: const Text(
              'Next',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          )
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

  void addImage(PickedFile image) => _pickedImages.add(image);

  void uploadPhotos(BuildContext context) {
    // TODO: all pictures
    final currentState = BlocProvider.of<CurrentUserCubit>(context).state
        as CurrentUserWithUserInstance;

    final user = currentState.user;
    BlocProvider.of<CurrentUserCubit>(context)
        .uploadPhoto(user, _pickedImages[0]);
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

class PhotoItem extends StatefulWidget {
  final Function addImage;

  const PhotoItem(this.addImage, {Key key}) : super(key: key);

  @override
  _PhotoItemState createState() => _PhotoItemState();
}

class _PhotoItemState extends State<PhotoItem> {
  PickedFile _image;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: InkWell(
        onTap: _getPhotoFromGallery,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: _image != null
              ? _showImage()
              : Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.grey[700],
                    size: 34,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _showImage() => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        height: double.infinity,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.file(
              File(_image.path),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      );

  Future _getPhotoFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (pickedImage != null) {
      widget.addImage(pickedImage);
      setState(() => _image = pickedImage);
    }
  }
}
