import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/main_view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'login_form.dart';

class LoginView extends StatelessWidget {
  LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthenticationRepository()),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoginFailure) {
                Get.rawSnackbar(
                  title: 'Authentication failure',
                  message: state.message,
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else if (state is AuthLoginError) {
                Get.rawSnackbar(
                    title: 'Error occured',
                    message: state.message,
                    snackPosition: SnackPosition.BOTTOM);
              } else if (state is AuthLoginSuccess) {
                goToMainView();
              }
            },
            builder: (context, state) {
              if (state is AuthInitial) {
                checkIfUserIsLoggedIn(context);
                return LoadingSpinner();
              }
              if (state is AuthWaiting) {
                return LoadingSpinner();
              }
              if (state is AuthLoginSuccess) {
                // show empty container before the new screen loads up
                return Container();
              }
              return buildLoginForm(context);
            },
          ),
        ),
      ),
    );
  }

  Widget buildLoginForm(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sign in',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30),
          LoginForm(),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Sign up.',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void checkIfUserIsLoggedIn(BuildContext context) =>
      BlocProvider.of<AuthBloc>(context).add(AuthCheckIfLoggedIn());

  void goToMainView() => Get.off(MainView());
}
