import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/presentation/universal_components/user_profile_item.dart';
import 'package:flutter/material.dart';

class MyProfileView extends StatelessWidget {
  MyProfileView({Key key}) : super(key: key);

  final fakeUser = User(
    id: 'asd',
    name: 'Chad',
    birthDate: DateTime(1996, 03, 02),
    gender: Gender.Man,
    caption: 'Jestem dobrym ziomem.\nFwb, Netflix and chill?',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: UserProfileItem(user: fakeUser, isMine: true),
    );
  }
}
