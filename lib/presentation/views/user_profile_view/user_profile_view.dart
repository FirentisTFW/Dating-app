import 'package:Dating_app/presentation/universal_components/user_profile_item/user_profile_item.dart';
import 'package:flutter/material.dart';

class UserProfileView extends StatelessWidget {
  final String userId;

  const UserProfileView(this.userId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          // TODO: get user data (maybe BLoC)
          // future: ,
          builder: (context, snapshot) {
        return UserProfileItem(
          user: snapshot.data,
        );
      }),
    );
  }
}
