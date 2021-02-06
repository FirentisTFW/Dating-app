import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/helpers/current_user_cubit_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/universal_components/next_button.dart';
import 'package:Dating_app/presentation/views/main_view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import 'components/discovery_settings_components.dart';

class DiscoverySettingsView extends StatefulWidget {
  const DiscoverySettingsView({Key key}) : super(key: key);

  @override
  _DiscoverySettingsViewState createState() => _DiscoverySettingsViewState();
}

class _DiscoverySettingsViewState extends State<DiscoverySettingsView> {
  var gender = Gender.Woman;
  var ageMin = 20;
  var ageMax = 25;
  var distance = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discovery Settings'),
      ),
      body: BlocListener<CurrentUserCubit, CurrentUserState>(
        listener: (context, state) {
          if (state is CurrentUserReady) {
            goToMainView();
          } else if (state is CurrentUserError) {
            CurrentUserCubitHelpers.showErrorSnackbar(state);
          }
        },
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.grey[700], fontSize: 18),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GenderSelector(setGender),
              AgeRangeSelector(setAgeRange),
              DistanceSelector(setDistance),
              const SizedBox(height: 50),
              BlocBuilder<CurrentUserCubit, CurrentUserState>(
                builder: (context, state) {
                  if (state is CurrentUserWaiting) {
                    return LoadingSpinner();
                  }
                  return NextButton(saveDiscoverySettings);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveDiscoverySettings() {
    final discoverySettings = DiscoverySettings(
      gender: gender,
      ageMin: ageMin,
      ageMax: ageMax,
      distance: distance,
    );

    final currentState = BlocProvider.of<CurrentUserCubit>(context).state
        as CurrentUserWithUserInstance;
    final user = currentState.user;

    BlocProvider.of<CurrentUserCubit>(context)
        .updateDiscoverySettings(user, discoverySettings);
  }

  void goToMainView() => Get.off(MainView());

  void setGender(Gender value) => gender = value;

  void setAgeRange(RangeValues values) {
    ageMin = values.start.round();
    ageMax = values.end.round();
  }

  void setDistance(double value) => distance = value.round();
}
