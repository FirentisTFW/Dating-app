import 'package:flutter/material.dart';

class PhotoIcon extends StatelessWidget {
  final String photoUrl;
  final double size;

  const PhotoIcon({Key key, @required this.photoUrl, @required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: photoUrl != null
              ? NetworkImage(photoUrl)
              : AssetImage('assets/images/unknown_avatar.png'),
        ),
      ),
    );
  }
}
