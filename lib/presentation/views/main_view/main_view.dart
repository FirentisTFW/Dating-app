import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainView extends StatelessWidget {
  const MainView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthCheckIfLoggedIn());
    // FirebaseAuth.instance.signOut();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('I am logged in!'),
      ),
    );
  }
}
