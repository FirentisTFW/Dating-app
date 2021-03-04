import 'package:flutter/material.dart';

class PhotoIcon extends StatelessWidget {
  final String photoUrl;
  final double size;
  final BoxFit fit;

  const PhotoIcon({
    Key key,
    @required this.photoUrl,
    @required this.size,
    this.fit = BoxFit.fitWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: fit,
          image: photoUrl != null
              ? NetworkImage(photoUrl)
              : AssetImage('assets/images/unknown_avatar.png'),
        ),
      ),
    );
  }
}
