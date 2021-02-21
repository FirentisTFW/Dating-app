import 'package:Dating_app/data/models/enums.dart';
import 'package:flutter/material.dart';

class GenderSelector extends StatefulWidget {
  final Function setGender;
  final Gender initialValue;

  GenderSelector(this.setGender, {Key key, this.initialValue = Gender.Woman})
      : super(key: key);

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  Gender gender;

  @override
  void initState() {
    super.initState();
    gender = widget.initialValue;
  }

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
  final int initialMin;
  final int initialMax;

  const AgeRangeSelector(
    this.setAgeRange, {
    Key key,
    this.initialMin = 20,
    this.initialMax = 25,
  }) : super(key: key);

  @override
  _AgeRangeSelectorState createState() => _AgeRangeSelectorState();
}

class _AgeRangeSelectorState extends State<AgeRangeSelector> {
  var ageRange = RangeValues(20, 25);

  @override
  void initState() {
    super.initState();
    ageRange =
        RangeValues(widget.initialMin.toDouble(), widget.initialMax.toDouble());
  }

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
  final int initialValue;

  DistanceSelector(this.setDistance, {Key key, this.initialValue = 20})
      : super(key: key);

  @override
  _DistanceSelectorState createState() => _DistanceSelectorState();
}

class _DistanceSelectorState extends State<DistanceSelector> {
  double distance;

  @override
  void initState() {
    super.initState();
    distance = widget.initialValue.toDouble();
  }

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
