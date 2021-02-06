import 'dart:io';

import 'package:Dating_app/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileItem extends StatelessWidget {
  final User user;
  final PickedFile userImage;
  final bool isMine;

  const UserProfileItem(
      {Key key, this.user, this.userImage, this.isMine = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 6,
          child: Container(
            child: Center(
              child: Image.file(
                // TODO: get real image
                // TODO: image slider
                // File(userImage.path),
                File(
                    '/storage/emulated/0/Android/data/com.example.Dating_app/files/Pictures/scaled_image_picker3960247600890254727.jpg'),
                // File(
                //     '/storage/emulated/0/Android/data/com.example.Dating_app/files/Pictures/scaled_image_picker4009970771082178266.jpg'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Flexible(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${user.name}, ${user.getAge().toString()}',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              if (!isMine)
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      // TODO: get real distance
                      child: Text('18 kilometers away',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 18)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Divider(color: Colors.grey[500]),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Text(
                  // 'To jest mój opis. Generalnie jestem dobrym ziomem. Elo elo 420To jest mój opis. Generalnie jestem dobrym ziomem. Elo elo 420To jest mój opis. Generalnie jestem dobrym ziomem. Elo elo 420To jest mój opis. Generalnie jestem dobrym ziomem. Elo elo 420To jest mój opis. Generalnie jestem dobrym ziomem. Elo elo 420To jest mój opis. Generalnie jestem dobrym ziomem. Elo elo 420To jest mój opis. Generalnie jestem dobrym ziomem. Elo elo 420',
                  '${user.caption}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        if (!isMine)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.close,
                    size: 38,
                    color: Colors.red,
                  ),
                  Icon(
                    Icons.check,
                    size: 38,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
