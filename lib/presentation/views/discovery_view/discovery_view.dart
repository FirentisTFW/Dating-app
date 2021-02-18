import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/dicovery_bloc/discovery_bloc.dart';
import 'package:Dating_app/logic/fake_users_creator.dart';
import 'package:Dating_app/presentation/helpers/current_user_cubit_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/universal_components/user_profile_item/user_profile_item.dart';
import 'package:Dating_app/presentation/views/discovery_settings_view/discovery_settings_view.dart';
import 'package:Dating_app/presentation/views/profile_creation_view/profile_creation_view.dart';
import 'package:Dating_app/presentation/views/user_photos_view/user_photos_view.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class DiscoveryView extends StatelessWidget {
  const DiscoveryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // createFakeUsers();
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
          } else if (state is CurrentUserError) {
            CurrentUserCubitHelpers.showErrorSnackbar(state);
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
          if (state is CurrentUserWaiting) {
            return LoadingSpinner();
          } else if (state is CurrentUserError) {
            return LoadingSpinner();
          } else if (state is CurrentUserProfileIncomplete) {
            // show empty container before the new screen loads up
            return Container();
          } else if (state is CurrentUserReady) {
            return Container(
              child: BlocConsumer<DiscoveryBloc, DiscoveryState>(
                listener: (context, state) {
                  if (state is DiscoveryActionError) {
                    print('Error!');
                  }
                },
                builder: (context, state) {
                  if (state is DiscoveryUsersFetched) {
                    print(state.users.length);
                    // TODO: check if there are users left
                    if (state.users.length > 0) {
                      return UserProfileItem(
                        user: state.users.first,
                        acceptUser: () => acceptUser(
                            context, state.users, state.users.first.id),
                        rejectUser: () => rejectUser(
                            context, state.users, state.users.first.id),
                      );
                    }
                    return Text('No users');
                  }
                  return LoadingSpinner();
                },
              ),
            );
            return FlatButton(
              child: Text('Test fest'),
              onPressed: () => Get.off(UserPhotosView()),
            );
          }
          return Text('Lipton');
        },
      ),
    );
  }

  void goToProfileCreationView() => Get.off(ProfileCreationView());

  void goToDiscoverySettingsView() => Get.off(DiscoverySettingsView());

  void acceptUser(
      BuildContext context, List<User> currentStateUsers, String acceptedUid) {
    final state = BlocProvider.of<CurrentUserCubit>(context).state
        as CurrentUserWithUserInstance;

    BlocProvider.of<DiscoveryBloc>(context).add(AcceptUser(currentStateUsers,
        acceptingUid: state.user.id, acceptedUid: acceptedUid));
  }

  void rejectUser(
      BuildContext context, List<User> currentStateUsers, String acceptedUid) {
    final state = BlocProvider.of<CurrentUserCubit>(context).state
        as CurrentUserWithUserInstance;

    BlocProvider.of<DiscoveryBloc>(context).add(RejectUser(currentStateUsers,
        rejectingUid: state.user.id, rejectedUid: acceptedUid));
  }
}

class _MyButtons extends StatelessWidget {
  const _MyButtons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          child: Text('Log out'),
          onPressed: () {
            // FirebaseAuth.instance.signOut();
          },
        ),
        FlatButton(
          child: Text('Create fake users'),
          onPressed: () {
            createFakeUsers();
          },
        ),
        BlocBuilder<CurrentUserCubit, CurrentUserState>(
          builder: (context, state) {
            if (state is CurrentUserWithUserInstance) {
              return FlatButton(
                child: Text('Fetch users'),
                onPressed: () async {
                  // TODO: get real rejected  users
                  BlocProvider.of<DiscoveryBloc>(context)
                      .add(FetchAndFilterUsers(user: state.user));
                },
              );
            }
            return LoadingSpinner();
          },
        )
      ],
    );
  }
}
