import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/dicovery_bloc/discovery_bloc.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/presentation/helpers/current_user_cubit_helpers.dart';
import 'package:Dating_app/presentation/helpers/discovery_bloc_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/universal_components/user_profile_item/user_profile_item.dart';
import 'package:Dating_app/presentation/views/discovery_settings_view/discovery_settings_view.dart';
import 'package:Dating_app/presentation/views/profile_creation_view/profile_creation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class DiscoveryView extends StatelessWidget {
  const DiscoveryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocConsumer<CurrentUserCubit, CurrentUserState>(
        listener: (context, state) {
          if (state is CurrentUserProfileIncomplete) {
            if (state.profileStatus == ProfileStatus.MissingPersonalData) {
              goToProfileCreationView();
            } else if (state.profileStatus ==
                ProfileStatus.MissingDiscoverySettings) {
              goToDiscoverySettingsView();
            }
          } else if (state is CurrentUserFailure) {
            CurrentUserCubitHelpers.showFailureSnackbar(state);
            Future.delayed(Duration(seconds: 5), () {
              BlocProvider.of<CurrentUserCubit>(context)
                  .checkIfProfileIsComplete();
            });
          } else if (state is CurrentUserWithUserInstance) {
            BlocProvider.of<DiscoveryBloc>(context)
                .add(FetchAndFilterUsers(user: state.user));
          }
        },
        builder: (context, state) {
          if (state is CurrentUserProfileIncomplete) {
            // show empty container before the new screen loads up
            return Container();
          } else if (state is CurrentUserReady) {
            return Container(
              child: BlocConsumer<DiscoveryBloc, DiscoveryState>(
                listener: (context, state) {
                  if (state is DiscoveryActionException) {
                    DiscoveryBlocHelpers.showErrorSnackbar(state);
                  }
                },
                builder: (context, state) {
                  if (state is DiscoveryUsersFetched) {
                    if (state.users.length > 0) {
                      return UserProfileItem(
                        user: state.users.first,
                        profileRelation: ProfileRelation.Discovered,
                        acceptUser: () => acceptUser(
                            context, state.users, state.users.first.id),
                        rejectUser: () => rejectUser(
                            context, state.users, state.users.first.id),
                      );
                    }
                    return noUsersInfo;
                  }
                  return LoadingSpinner();
                },
              ),
            );
          }
          return LoadingSpinner();
        },
      ),
    );
  }

  final noUsersInfo = const Padding(
    padding: EdgeInsets.all(20),
    child: Center(
      child: Text(
        'No users found. You might want to change your discovery settings.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22),
      ),
    ),
  );

  void goToProfileCreationView() => Get.off(ProfileCreationView());

  void goToDiscoverySettingsView() =>
      Get.off(DiscoverySettingsView(firstTime: true));

  void acceptUser(
      BuildContext context, List<User> currentStateUsers, String acceptedUid) {
    final userData = locator<CurrentUserData>();

    if (userData.isUserSet) {
      BlocProvider.of<DiscoveryBloc>(context).add(AcceptUser(currentStateUsers,
          acceptingUid: userData.userId, acceptedUid: acceptedUid));
    }
  }

  void rejectUser(
      BuildContext context, List<User> currentStateUsers, String acceptedUid) {
    final userData = locator<CurrentUserData>();

    if (userData.isUserSet) {
      BlocProvider.of<DiscoveryBloc>(context).add(RejectUser(currentStateUsers,
          rejectingUid: userData.userId, rejectedUid: acceptedUid));
    }
  }
}
