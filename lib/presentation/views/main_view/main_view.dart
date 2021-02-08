import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/helpers/current_user_cubit_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/discovery_settings_view/discovery_settings_view.dart';
import 'package:Dating_app/presentation/views/my_profile_view/my_profile_view.dart';
import 'package:Dating_app/presentation/views/profile_creation_view/profile_creation_view.dart';
import 'package:Dating_app/presentation/views/user_photos_view/user_photos_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class MainView extends StatelessWidget {
  const MainView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CurrentUserCubit>(context).checkIfProfileIsComplete();
    // FirebaseAuth.instance.signOut();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.account_circle, size: 28),
              onPressed: goToMyProfileView,
            ),
            IconButton(
              icon: Icon(Icons.add_circle, size: 34),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.chat, size: 28),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: BlocConsumer<CurrentUserCubit, CurrentUserState>(
        listener: (context, state) {
          if (state is CurrentUserProfileIncomplete) {
            if (state.user.name == null) {
              goToProfileCreationView();
            } else if (state.user.discoverySettings == null) {
              goToDiscoverySettingsView();
            }
          } else if (state is CurrentUserError) {
            CurrentUserCubitHelpers.showErrorSnackbar(state);
            BlocProvider.of<CurrentUserCubit>(context)
                .checkIfProfileIsComplete();
          }
        },
        builder: (context, state) {
          if (state is CurrentUserWaiting) {
            return LoadingSpinner();
          } else if (state is CurrentUserError) {
            return LoadingSpinner();
          } else if (state is CurrentUserProfileIncomplete) {
            // show empty container before the new screen loads up
            return Container();
          }
          return FlatButton(
            child: Text('Test fest'),
            onPressed: () => Get.off(DiscoverySettingsView()),
          );
        },
      ),
    );
  }

  void goToMyProfileView() => Get.to(MyProfileView());

  void goToProfileCreationView() => Get.off(ProfileCreationView());

  void goToDiscoverySettingsView() => Get.off(DiscoverySettingsView());
}
