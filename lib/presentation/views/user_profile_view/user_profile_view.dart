import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/universal_components/user_profile_item/user_profile_item.dart';
import 'package:flutter/material.dart';

class UserProfileView extends StatelessWidget {
  final String userId;
  final usersRepository = UsersRepository();

  UserProfileView(this.userId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: usersRepository.getUserById(userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return UserProfileItem(
              user: snapshot.data,
              profileRelation: ProfileRelation.Matched,
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occured. Try again.'));
          }
          return LoadingSpinner();
        },
      ),
    );
  }
}
