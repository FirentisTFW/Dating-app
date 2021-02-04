import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:Dating_app/presentation/helpers/auth_bloc_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/main_view/main_view.dart';
import 'package:Dating_app/presentation/views/profile_creation_view/profile_creation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'components/auth_form.dart';

class AuthView extends StatefulWidget {
  AuthView({Key key}) : super(key: key);

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  AuthType _formType = AuthType.Login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginSuccess) {
              goToMainView();
            } else if (state is AuthRegistrationSuccess) {
              goToProfileCreationView();
            } else if (state is AuthFailure) {
              AuthBlocHelpers.showFailureSnackbar(state);
            } else if (state is AuthError) {
              AuthBlocHelpers.showErrorSnackbar(state);
            }
          },
          builder: (context, state) {
            if (state is AuthLoginSuccess || state is AuthRegistrationSuccess) {
              // show empty container before the new screen loads up
              return Container();
            }
            return buildAuthForm(context);
          },
        ),
      ),
    );
  }

  Widget buildAuthForm(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _formType == AuthType.Login ? 'Sign in' : 'Sign up',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30),
          AuthForm(_formType),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formType == AuthType.Login
                      ? 'Don\'t have an account? '
                      : 'Already have an account? ',
                  style: TextStyle(fontSize: 16),
                ),
                InkWell(
                  onTap: changeFormType,
                  child: Text(
                    _formType == AuthType.Login ? 'Sign up.' : 'Sign in',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void goToMainView() => Get.off(MainView());

  void goToProfileCreationView() => Get.off(ProfileCreationView());

  void changeFormType() {
    setState(() {
      if (_formType == AuthType.Login) {
        _formType = AuthType.Registration;
      } else {
        _formType = AuthType.Login;
      }
    });
  }
}
