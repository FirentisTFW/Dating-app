import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/dicovery_bloc/discovery_bloc.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/presentation/helpers/snackbar_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/universal_components/user_profile_item/user_profile_item.dart';
import 'package:Dating_app/presentation/views/discovery_settings_view/discovery_settings_view.dart';
import 'package:Dating_app/presentation/views/profile_creation_view/profile_creation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'dart:math' as math;

class DiscoveryView extends StatelessWidget {
  DiscoveryView({Key key}) : super(key: key);

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
            SnackbarHelpers.showFailureSnackbar(state.message);
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
                    SnackbarHelpers.showFailureSnackbar(state.message);
                  }
                },
                builder: (context, state) {
                  if (state is DiscoveryUsersFetched) {
                    if (state.users.length > 0) {
                      return _buildUserProfileItem(context, state);
                    }
                    return _noUsersInfo;
                  }
                  return LoadingSpinner(
                    key: ValueKey('DiscoveryViewDiscoveryLoadingSpinner'),
                  );
                },
              ),
            );
          }
          return LoadingSpinner(
            key: ValueKey('DiscoveryViewCurrentUserLoadingSpinner'),
          );
        },
      ),
    );
  }

  final _noUsersInfo = const Padding(
    padding: EdgeInsets.all(20),
    child: Center(
      child: Text(
        'No users found. You might want to change your discovery settings.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22),
      ),
    ),
  );

  final _dismissibleFirstBackground = Row(
    children: [
      const _DismissibleBackgroundText(
        text: 'LIKE',
        color: const Color(0xFF00CC00),
        isLike: true,
      ),
    ],
  );

  final _dismissibleSecondBackground = Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      const _DismissibleBackgroundText(
        text: 'NOPE',
        color: const Color(0xFFCC0000),
        isLike: false,
      ),
    ],
  );

  Widget _buildUserProfileItem(
      BuildContext context, DiscoveryUsersFetched state) {
    return Dismissible(
      key: ValueKey(state.users.first.id),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          acceptUser(context, state.users, state.users.first.id);
        } else if (direction == DismissDirection.endToStart) {
          rejectUser(context, state.users, state.users.first.id);
        }
      },
      crossAxisEndOffset: -0.2,
      background: _dismissibleFirstBackground,
      secondaryBackground: _dismissibleSecondBackground,
      child: UserProfileItem(
        user: state.users.first,
        profileRelation: ProfileRelation.Discovered,
        acceptUser: () =>
            acceptUser(context, state.users, state.users.first.id),
        rejectUser: () =>
            rejectUser(context, state.users, state.users.first.id),
      ),
    );
  }

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

class _DismissibleBackgroundText extends StatelessWidget {
  final String text;
  final Color color;
  final bool isLike;

  const _DismissibleBackgroundText(
      {Key key,
      @required this.text,
      @required this.color,
      @required this.isLike})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isLike
          ? const EdgeInsets.only(left: 30)
          : const EdgeInsets.only(right: 30),
      child: Transform(
        alignment: isLike ? Alignment.topRight : Alignment.topLeft,
        transform: isLike
            ? Matrix4.rotationZ(-math.pi / 10.0)
            : Matrix4.rotationZ(math.pi / 10.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 3.0,
              color: color,
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
