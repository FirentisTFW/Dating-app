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

class GenderSelector extends StatefulWidget {
  final Function setGender;

  GenderSelector(this.setGender, {Key key}) : super(key: key);

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  var gender = Gender.Woman;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              const Expanded(child: Text('Looking for')),
              DropdownButton(
                  value: gender,
                  items: [
                    const DropdownMenuItem(
                        value: Gender.Woman, child: Text('Women')),
                    const DropdownMenuItem(
                        value: Gender.Man, child: Text('Men')),
                  ],
                  underline: Container(),
                  icon: Padding(
                    padding: gender == Gender.Woman
                        ? const EdgeInsets.only(left: 16)
                        : const EdgeInsets.only(),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[700], fontSize: 18),
                  onChanged: (value) {
                    setState(() => gender = value);
                    widget.setGender(value);
                  }),
            ],
          ),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}

class AgeRangeSelector extends StatefulWidget {
  final Function setAgeRange;

  const AgeRangeSelector(this.setAgeRange, {Key key}) : super(key: key);

  @override
  _AgeRangeSelectorState createState() => _AgeRangeSelectorState();
}

class _AgeRangeSelectorState extends State<AgeRangeSelector> {
  var ageRange = RangeValues(20, 25);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              const Expanded(child: Text('Age Range')),
              Text(
                  '${ageRange.start.round().toString()} - ${ageRange.end.round().toString()}'),
            ],
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Theme.of(context).primaryColor,
            thumbColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Colors.grey[400],
            trackHeight: 4,
          ),
          child: RangeSlider(
            min: 18,
            max: 60,
            values: ageRange,
            onChanged: (values) => setState(() => ageRange = values),
            onChangeEnd: widget.setAgeRange,
          ),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}

class DistanceSelector extends StatefulWidget {
  final Function setDistance;

  DistanceSelector(this.setDistance, {Key key}) : super(key: key);

  @override
  _DistanceSelectorState createState() => _DistanceSelectorState();
}

class _DistanceSelectorState extends State<DistanceSelector> {
  var distance = 20.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              const Expanded(child: Text('Distance')),
              Text('${distance.round().toString()} km'),
            ],
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Theme.of(context).primaryColor,
            thumbColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Colors.grey[400],
            trackHeight: 4,
          ),
          child: Slider(
            value: distance,
            max: 100,
            onChanged: (value) => setState(() => distance = value),
            onChangeEnd: widget.setDistance,
          ),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}
