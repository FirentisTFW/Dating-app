import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/universal_components/user_profile_item/user_profile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileView extends StatelessWidget {
  MyProfileView({Key key}) : super(key: key);

  // final fakeUser = User(
  //     id: 'gIzISF1o6Gfau0SqV1arDCZNtKO2',
  //     name: 'Chad',
  //     birthDate: DateTime(1996, 03, 02),
  //     gender: Gender.Man,
  //     caption: 'Jestem dobrym ziomem.\nFwb, Netflix and chill?',
  //     location: CustomLocation(latitude: 37.429836, longitude: -122.169428),
  //     photosRef: [
  //       '1612459337933',
  //       '1612459339204',
  //     ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<CurrentUserCubit, CurrentUserState>(
        builder: (context, state) {
          if (state is CurrentUserWithUserInstance) {
            return UserProfileItem(user: state.user, isMine: true);
          } else {
            return LoadingSpinner();
          }
        },
      ),
    );
  }
}
