import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/universal_components/user_profile_item/user_profile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileView extends StatelessWidget {
  MyProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<CurrentUserCubit, CurrentUserState>(
        builder: (context, state) {
          if (state is CurrentUserWithUserInstance) {
            return UserProfileItem(
                user: state.user, profileRelation: ProfileRelation.Mine);
          } else {
            return LoadingSpinner();
          }
        },
      ),
    );
  }
}
