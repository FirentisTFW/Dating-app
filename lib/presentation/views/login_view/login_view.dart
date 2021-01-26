import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthWaiting) {
                return LoadingSpinner();
              } else if (state is AuthLoginSuccess) {
                return Text('Logged in! Hurraaaa!');
              } else if (state is AuthLoginFailure) {
                return Text('Failure!');
              } else if (state is AuthLoginError) {
                return Text('Error!');
              }
              return buildSignInForm(context);
            },
          ),
        ),
      ),
    );
  }

  Widget buildSignInForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
