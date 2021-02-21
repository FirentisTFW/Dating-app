import 'package:flutter/material.dart';

import 'photo_item.dart';

class PhotosRow extends StatelessWidget {
  final Function addImage;
  final Function removeOldImage;
  final List<String> initialPhotosUrls;

  const PhotosRow(this.addImage,
      {Key key, this.removeOldImage, this.initialPhotosUrls = const []})
      : super(key: key);

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
            addImage,
            removeImage: removeOldImage,
            initialPhotoUrl: initialPhotosUrls[i],
          ),
        );
      } else {
        items.add(
          PhotoItem(addImage),
        );
      }

      items.add(const Expanded(child: SizedBox()));
    }

    return items;
  }
}
