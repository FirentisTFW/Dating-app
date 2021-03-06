import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/repositories/location_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/dicovery_bloc/discovery_bloc.dart';
import 'package:Dating_app/logic/matches_cubit/matches_cubit.dart';
import 'package:Dating_app/logic/messages_cubit/messages_cubit.dart';
import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:Dating_app/presentation/views/auth_view/auth_view.dart';
import 'package:Dating_app/presentation/views/main_view/main_view.dart';
import 'package:Dating_app/presentation/views/splash_view/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'data/repositories/authentication_repository.dart';
import 'data/repositories/conversations_repository.dart';
import 'data/repositories/photos_repository.dart';
import 'logic/auth_bloc/auth_bloc.dart';
import 'logic/conversations_cubit/conversations_cubit.dart';
import 'presentation/setup/themes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _authRepository = AuthenticationRepository();
  final _usersRepository = UsersRepository();
  final _photosRepository = PhotosRepository();
  final _locationRepository = LocationRepository();
  final _conversationsRepository = ConversationsRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(_authRepository),
        ),
        BlocProvider<CurrentUserCubit>(
          create: (context) => CurrentUserCubit(
              _usersRepository, _authRepository, _locationRepository),
        ),
        BlocProvider<PhotosCubit>(
          create: (context) => PhotosCubit(_photosRepository),
        ),
        BlocProvider<DiscoveryBloc>(
          create: (context) => DiscoveryBloc(_usersRepository),
        ),
        BlocProvider<MatchesCubit>(
          create: (context) => MatchesCubit(_usersRepository),
        ),
        BlocProvider<ConversationsCubit>(
          create: (context) =>
              ConversationsCubit(_usersRepository, _conversationsRepository),
        ),
        BlocProvider<MessagesCubit>(
          create: (context) => MessagesCubit(_conversationsRepository),
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
          buildWhen: (previous, current) => !(current is AuthWaiting),
          builder: (context, state) {
            if (state is AuthInitial) {
              BlocProvider.of<AuthBloc>(context).add(AuthCheckIfLoggedIn());
              return SplashView();
            }
            return AuthView();
          },
        ),
      ),
    );
  }
}
