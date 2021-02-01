import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPhotosView extends StatelessWidget {
  const UserPhotosView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            padding: const EdgeInsets.only(right: 10),
            onPressed: () {},
            child: Text(
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
            PhotosRow(),
            const Expanded(child: SizedBox()),
            PhotosRow(),
            const Expanded(child: SizedBox()),
            PhotosRow(),
          ],
        ),
      ),
    );
  }
}

class PhotosRow extends StatelessWidget {
  const PhotosRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          PhotoItem(),
          const Expanded(child: SizedBox()),
          PhotoItem(),
          const Expanded(child: SizedBox()),
          PhotoItem(),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class PhotoItem extends StatefulWidget {
  const PhotoItem({Key key}) : super(key: key);

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
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
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
                )
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

  Future _getPhotoFromGallery() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() => _image = image);
  }
}
