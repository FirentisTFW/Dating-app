import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/logic/dicovery_bloc/discovery_bloc.dart';
import 'package:Dating_app/presentation/helpers/current_user_cubit_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/universal_components/next_button.dart';
import 'package:Dating_app/presentation/views/main_view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import 'components/discovery_settings_components.dart';

class DiscoverySettingsView extends StatefulWidget {
  final bool firstTime;

  const DiscoverySettingsView({Key key, this.firstTime = false})
      : super(key: key);

  @override
  _DiscoverySettingsViewState createState() => _DiscoverySettingsViewState();
}

class _DiscoverySettingsViewState extends State<DiscoverySettingsView> {
  Gender gender;
  int ageMin;
  int ageMax;
  int distance;

  @override
  void initState() {
    super.initState();
    setCurrentSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discovery Settings'),
      ),
      body: BlocConsumer<CurrentUserCubit, CurrentUserState>(
        listener: (context, state) {
          if (state is CurrentUserReady) {
            widget.firstTime ? goToMainView() : Get.back();
          } else if (state is CurrentUserFailure) {
            CurrentUserCubitHelpers.showFailureSnackbar(state);
          }
        },
        builder: (context, state) {
          if (state is CurrentUserReady) {
            return DefaultTextStyle(
              style: TextStyle(color: Colors.grey[700], fontSize: 18),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  GenderSelector(setGender, initialValue: gender),
                  AgeRangeSelector(
                    setAgeRange,
                    initialMin: ageMin,
                    initialMax: ageMax,
                  ),
                  DistanceSelector(setDistance, initialValue: distance),
                  const SizedBox(height: 50),
                  BlocBuilder<CurrentUserCubit, CurrentUserState>(
                    builder: (context, state) {
                      if (state is CurrentUserWaiting) {
                        return LoadingSpinner();
                      }
                      return DoneButton(saveDiscoverySettings);
                    },
                  )
                ],
              ),
            );
          }
          return LoadingSpinner();
        },
      ),
    );
  }

  void setCurrentSettings() {
    if (widget.firstTime) {
      gender = Gender.Woman;
      ageMin = 20;
      ageMax = 25;
      distance = 20;
    } else {
      final userData = locator<CurrentUserData>();

      gender = userData.user.discoverySettings.gender;
      ageMin = userData.user.discoverySettings.ageMin;
      ageMax = userData.user.discoverySettings.ageMax;
      distance = userData.user.discoverySettings.distance;
    }
  }

  Future<void> saveDiscoverySettings() async {
    final discoverySettings = DiscoverySettings(
      gender: gender,
      ageMin: ageMin,
      ageMax: ageMax,
      distance: distance,
    );

    final userData = locator<CurrentUserData>();

    await BlocProvider.of<CurrentUserCubit>(context)
        .updateDiscoverySettings(userData.user, discoverySettings);

    BlocProvider.of<DiscoveryBloc>(context)
        .add(FetchAndFilterUsers(user: userData.user));
  }

  void goToMainView() => Get.off(MainView());

  void setGender(Gender value) => gender = value;

  void setAgeRange(RangeValues values) {
    ageMin = values.start.round();
    ageMax = values.end.round();
  }

  void setDistance(double value) => distance = value.round();
}
