import 'package:Dating_app/presentation/views/auth_view/auth_view.dart';
import 'package:Dating_app/presentation/views/main_view/main_view.dart';
import 'package:Dating_app/presentation/views/splash_view/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'data/repositories/authentication_repository.dart';
import 'logic/auth_bloc/auth_bloc.dart';
import 'presentation/setup/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthenticationRepository()),
      child: GetMaterialApp(
        title: 'Dating App',
        theme: lightTheme,
        home: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginSuccess) {
              Get.off(MainView());
            }
          },
          builder: (context, state) {
            if (state is AuthInitial) {
              BlocProvider.of<AuthBloc>(context).add(AuthCheckIfLoggedIn());
              return SplashView();
            }
            return AuthView();
          },
          buildWhen: (previous, current) => !(current is AuthWaiting),
        ),
      ),
    );
  }
}
