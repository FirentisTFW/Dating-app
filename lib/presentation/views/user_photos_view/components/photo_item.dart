import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
