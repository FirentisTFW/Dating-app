import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/user_photos_view/user_photos_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

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
      body: Padding(
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
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Name'),
                    cursorColor: Theme.of(context).primaryColor,
                    validator:
                        Validators.required('This field can\'t be empty'),
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
                  _DateSelection(_birthDate, _setBirthDate),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Caption'),
                    cursorColor: Theme.of(context).primaryColor,
                    minLines: 4,
                    maxLines: 6,
                    onSaved: _setCaption,
                  ),
                  const SizedBox(height: 30),
                  BlocConsumer<CurrentUserCubit, CurrentUserState>(
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
    );
  }

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

class _DateSelection extends StatelessWidget {
  final DateTime _birthDate;
  final Function _setBirthDate;

  const _DateSelection(this._birthDate, this._setBirthDate, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: FlatButton(
        padding: const EdgeInsets.all(0),
        minWidth: double.infinity,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Birth date: ' +
                (_birthDate != null
                    ? DateFormat('yMd').format(_birthDate)
                    : ''),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        onPressed: () => DatePicker.showDatePicker(
          context,
          currentTime: DateTime(DateTime.now().year - 20),
          maxTime: DateTime.now(),
          theme: DatePickerTheme(
            itemHeight: 40,
            itemStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
            cancelStyle: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
            doneStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          onConfirm: _setBirthDate,
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final Function confirm;

  const NextButton(this.confirm, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: confirm,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: const Text(
            'Next',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
