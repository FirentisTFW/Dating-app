import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/views/auth_view/auth_view.dart';
import 'package:Dating_app/presentation/views/main_view/main_view.dart';
import 'package:Dating_app/presentation/views/profile_creation_view/profile_creation_view.dart';
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
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(AuthenticationRepository()),
        ),
        BlocProvider<CurrentUserCubit>(
          create: (context) => CurrentUserCubit(UsersRepository()),
        ),
      ],
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
            // TEST ONLY
            return ProfileCreationView();
            return AuthView();
          },
          buildWhen: (previous, current) => !(current is AuthWaiting),
        ),
      ),
    );
  }
}
