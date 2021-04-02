import 'package:flutter/material.dart';

import 'photo_item.dart';

class PhotosRow extends StatelessWidget {
  final Function addImage;
  final Function removeOldImage;
  final Function removePickedImage;
  final List<String> initialPhotosUrls;

  const PhotosRow({
    Key key,
    this.addImage,
    this.removeOldImage,
    this.removePickedImage,
    this.initialPhotosUrls = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(
        children: buildPhotoItems(),
      ),
    );
  }

  List<Widget> buildPhotoItems() {
    List<Widget> items = [const Expanded(child: SizedBox())];

    for (int i = 0; i < 3; i++) {
      if (i < initialPhotosUrls.length) {
        items.add(
          PhotoItem(
            addImage: addImage,
            removeOldImage: removeOldImage,
            initialPhotoUrl: initialPhotosUrls[i],
          ),
        );
      } else {
        items.add(
          PhotoItem(
            addImage: addImage,
            removePickedImage: removePickedImage,
          ),
        );
      }

      items.add(const Expanded(child: SizedBox()));
    }

    return items;
  }
}
