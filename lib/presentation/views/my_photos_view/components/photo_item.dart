import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoItem extends StatefulWidget {
  final Function addImage;
  final Function(BuildContext context, String photoUrl) removeOldImage;
  final Function(PickedFile pickedImage) removePickedImage;
  final String initialPhotoUrl;

  const PhotoItem({
    Key key,
    this.addImage,
    this.removeOldImage,
    this.removePickedImage,
    this.initialPhotoUrl,
  }) : super(key: key);

  @override
  _PhotoItemState createState() => _PhotoItemState();
}

class _PhotoItemState extends State<PhotoItem> {
  PickedFile _pickedImage;

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
          child: widget.initialPhotoUrl != null && widget.removeOldImage != null
              ? _showImage(initialUrl: widget.initialPhotoUrl)
              : _pickedImage != null
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

  Widget _showImage({String initialUrl}) => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        height: double.infinity,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FittedBox(
                fit: BoxFit.cover,
                child: initialUrl != null
                    ? Image.network(
                        initialUrl,
                        fit: BoxFit.fitWidth,
                      )
                    : Image.file(
                        File(_pickedImage.path),
                        fit: BoxFit.fitWidth,
                      ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () => initialUrl != null
                      ? widget.removeOldImage(context, initialUrl)
                      : _removePickedImage(),
                  child: ClipOval(
                    child: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Future _getPhotoFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (pickedImage != null) {
      widget.addImage(pickedImage);
      setState(() => _pickedImage = pickedImage);
    }
  }

  void _removePickedImage() {
    widget.removePickedImage(_pickedImage);
    setState(() => _pickedImage = null);
  }
}
