import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/user_photos_view/user_photos_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import 'components/date_selection_field.dart';
import 'components/next_button.dart';

class ProfileCreationView extends StatefulWidget {
  const ProfileCreationView({Key key}) : super(key: key);

  @override
  _ProfileCreationViewState createState() => _ProfileCreationViewState();
}

class _ProfileCreationViewState extends State<ProfileCreationView> {
  String _name;
  Gender _gender;
  DateTime _birthDate;
  String _caption;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CurrentUserCubit, CurrentUserState>(
        listener: (context, state) {
          if (state is CurrentUserError) {
            Get.rawSnackbar(
              title: 'Error occured',
              message: state.message ?? 'Please try again.',
              snackPosition: SnackPosition.BOTTOM,
            );
          } else if (state is CurrentUserProfileIncomplete) {
            goToUserPhotosView();
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
                        return NextButton(createUser);
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
    var isValid = _formKey.currentState.validate();

    if (_birthDate == null) {
      Get.rawSnackbar(
        title: 'Birth date missing',
        message: 'Please provide birth date.',
      );
      return;
    }

    if (isValid && _birthDate != null) {
      _formKey.currentState.save();

      final uid = firebase.FirebaseAuth.instance.currentUser.uid;
      final newUser = User(
        id: uid,
        name: _name,
        birthDate: _birthDate,
        gender: _gender,
        caption: _caption,
      );

      BlocProvider.of<CurrentUserCubit>(context).createUser(newUser);
    }
  }

  void goToUserPhotosView() => Get.off(UserPhotosView());

  void _setName(String value) => _name = value;

  void _setGender(Gender value) => _gender = value;

  void _setBirthDate(DateTime value) => setState(() => _birthDate = value);

  void _setCaption(String value) => _caption = value;
}
