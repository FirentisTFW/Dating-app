import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/views/profile_creation_view/profile_creation_view.dart';
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
      appBar: AppBar(),
      body: BlocConsumer<CurrentUserCubit, CurrentUserState>(
        listener: (context, state) {
          if (state is CurrentUserProfileIncomplete) {
            if (state.user.name == null) {
              goToProfileCreationView();
            }
            // TODO: if searching criteria is missing, go to the screen with them
          }
        },
        builder: (context, state) {
          print(state);
          return Center(
            child: Text('I am logged in!'),
          );
        },
      ),
    );
  }

  void goToProfileCreationView() => Get.off(ProfileCreationView());
}
