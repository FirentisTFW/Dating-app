import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/helpers/auth_bloc_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/universal_components/user_profile_item/user_profile_item.dart';
import 'package:Dating_app/presentation/views/auth_view/auth_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class MyProfileView extends StatelessWidget {
  MyProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSignOutSuccess) {
            goToAuthView();
          } else if (state is AuthFailure) {
            AuthBlocHelpers.showFailureSnackbar(state);
          }
        },
        builder: (context, state) {
          if (state is AuthWaiting) {
            return LoadingSpinner();
          } else if (state is AuthSignOutSuccess) {
            // show empty container before the new screen loads up
            return Container();
          }
          return BlocBuilder<CurrentUserCubit, CurrentUserState>(
            builder: (context, state) {
              if (state is CurrentUserWithUserInstance) {
                return UserProfileItem(
                    user: state.user, profileRelation: ProfileRelation.Mine);
              } else {
                return LoadingSpinner();
              }
            },
          );
        },
      ),
    );
  }

  void goToAuthView() => Get.off(AuthView());
}
