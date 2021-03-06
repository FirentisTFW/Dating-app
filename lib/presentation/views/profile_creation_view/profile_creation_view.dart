import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/helpers/snackbar_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/my_photos_view/my_photos_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import 'components/date_selection_field.dart';
import '../../universal_components/next_button.dart';

class ProfileCreationView extends StatefulWidget {
  const ProfileCreationView({Key key}) : super(key: key);

  @override
  _ProfileCreationViewState createState() => _ProfileCreationViewState();
}

class _ProfileCreationViewState extends State<ProfileCreationView> {
  String _name;
  Gender _gender;
  DateTime _birthDate;
  String _caption = '';
  CustomLocation _location;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CurrentUserCubit>(context).getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CurrentUserCubit, CurrentUserState>(
        listener: (context, state) {
          if (state is CurrentUserProfileIncomplete) {
            goToMyPhotosView();
          } else if (state is CurrentUserLocationReceived) {
            _location = state.location;
          } else if (state is CurrentUserFailure) {
            SnackbarHelpers.showFailureSnackbar(state.message);
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: ListView(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Set up your profile',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ..._buildFormFields(),
                    BlocBuilder<CurrentUserCubit, CurrentUserState>(
                      builder: (context, state) {
                        if (state is CurrentUserWaiting) {
                          return LoadingSpinner();
                        }
                        return DoneButton(createUser);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() => [
        TextFormField(
          decoration: const InputDecoration(hintText: 'Name'),
          cursorColor: Theme.of(context).primaryColor,
          validator: Validators.required('This field can\'t be empty'),
          onSaved: _setName,
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField(
          value: Gender.Man,
          items: [
            const DropdownMenuItem(
              child: Text('Man'),
              value: Gender.Man,
            ),
            const DropdownMenuItem(
              child: Text('Woman'),
              value: Gender.Woman,
            ),
          ],
          onChanged: (_) {},
          onSaved: _setGender,
        ),
        const SizedBox(height: 20),
        DateSelectionField(_birthDate, _setBirthDate),
        const SizedBox(height: 20),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Caption'),
          cursorColor: Theme.of(context).primaryColor,
          minLines: 4,
          maxLines: 6,
          onSaved: _setCaption,
        ),
        const SizedBox(height: 30),
      ];

  void createUser() {
    FocusScope.of(context).unfocus();

    if (_birthDate == null) {
      Get.rawSnackbar(
        title: 'Birth date missing',
        message: 'Please provide birth date.',
      );
      return;
    }

    if (_location == null) {
      Get.rawSnackbar(
        title: 'Location missing',
        message: 'Please allow application to use device location.',
      );
      return;
    }

    final isValid = _formKey.currentState.validate();

    if (isValid) {
      _formKey.currentState.save();

      final genderIndicator = _gender == Gender.Man ? 'm' : 'w';
      final uid =
          genderIndicator + firebase.FirebaseAuth.instance.currentUser.uid;
      final newUser = User(
        id: uid,
        name: _name,
        birthDate: _birthDate,
        gender: _gender,
        caption: _caption,
        location: _location,
      );

      BlocProvider.of<CurrentUserCubit>(context).createUser(newUser);
    }
  }

  void goToMyPhotosView() => Get.off(MyPhotosView(firstTime: true));

  void _setName(String value) => _name = value;

  void _setGender(Gender value) => _gender = value;

  void _setBirthDate(DateTime value) => setState(() => _birthDate = value);

  void _setCaption(String value) => _caption = value;
}
