import 'package:Dating_app/data/data_providers/authentication_provider.dart';
import 'package:Dating_app/data/data_providers/firestore_provider.dart';
import 'package:Dating_app/data/data_providers/location_provider.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:Dating_app/data/repositories/location_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/conversations_matches_view/conversations_matches_view.dart';
import 'package:Dating_app/presentation/views/discovery_settings_view/discovery_settings_view.dart';
import 'package:Dating_app/presentation/views/discovery_view/discovery_view.dart';
import 'package:Dating_app/presentation/views/main_view/main_view.dart';
import 'package:Dating_app/presentation/views/my_profile_view/my_profile_view.dart';
import 'package:Dating_app/presentation/views/profile_creation_view/profile_creation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dating_app/app/locator.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class AuthenticationProviderMock extends Mock
    implements AuthenticationProvider {}

class LocationProviderMock extends Mock implements LocationProvider {}

class FirestoreProviderMock extends Mock implements FirestoreProvider {}

class UsersRepositoryMock extends Mock implements UsersRepository {}

class AuthenticationRepositoryMock extends Mock
    implements AuthenticationRepository {}

class LocationRepositoryMock extends Mock implements LocationRepository {}

class AuthBlocMock extends Mock implements AuthBloc {}

class CurrentUserCubitMock extends Mock implements CurrentUserCubit {}

void main() {
  group('MainViewTest -', () {
    UsersRepository usersRepository;
    AuthenticationRepository authRepository;
    LocationRepository locationRepository;
    AuthBloc authBloc;
    CurrentUserCubit currentUserCubit;

    setUp(() {
      Get.testMode = true; // for Get navigation testing

      setupLocator();

      usersRepository = UsersRepositoryMock();
      authRepository = AuthenticationRepositoryMock();
      locationRepository = LocationRepositoryMock();

      authBloc = AuthBloc(authRepository);
      currentUserCubit =
          CurrentUserCubit(usersRepository, authRepository, locationRepository);
    });
    tearDown(() {
      resetLocator();
    });

    testWidgets('When first started, view shows loading spinner',
        (tester) async {
      await _pumpViewWithBlocProviders(tester, authBloc, currentUserCubit);

      expect(find.byType(LoadingSpinner), findsOneWidget);
    });
    testWidgets('When first started, current shown tab is Discovery View',
        (tester) async {
      await _pumpViewWithBlocProviders(tester, authBloc, currentUserCubit);

      expect(find.byType(DiscoveryView), findsOneWidget);
      expect(find.byType(ConversationsMatchesView), findsNothing);
      expect(find.byType(MyProfileView), findsNothing);
    });

    group('DiscoveryView -', () {
      testWidgets(
          'When user profie is incomplete (missing personal data), navigates to ProfileCreationView',
          (tester) async {
        when(usersRepository.getUserByAuthId(any))
            .thenAnswer((_) async => null);

        await _pumpViewWithBlocProviders(tester, authBloc, currentUserCubit);
        await tester.pumpAndSettle();

        expect(find.byType(ProfileCreationView), findsOneWidget);
        expect(find.byType(DiscoveryView), findsNothing);
      });
      testWidgets(
          'When user profie is incomplete (missing discovery settings), navigates to DiscoverySettingsView',
          (tester) async {
        when(usersRepository.getUserByAuthId(any))
            .thenAnswer((_) async => _userMissingDiscoverySettings);

        await _pumpViewWithBlocProviders(tester, authBloc, currentUserCubit);
        await tester.pumpAndSettle();

        expect(find.byType(DiscoverySettingsView), findsOneWidget);
        expect(find.byType(DiscoveryView), findsNothing);
      });
    });
  });
}

Future<void> _pumpViewWithBlocProviders(WidgetTester tester, AuthBloc authBloc,
    CurrentUserCubit currentUserCubit) async {
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<CurrentUserCubit>.value(value: currentUserCubit),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => MainView(),
        },
      ),
    ),
  );
}

final _userMissingDiscoverySettings = User(
  id: '1',
  name: 'Chad',
  birthDate: DateTime(1995, 01, 01),
  gender: Gender.Man,
  caption: 'Im Chad',
  discoverySettings: null,
);

void setupLocator() {
  locator
      .registerSingleton<AuthenticationProvider>(AuthenticationProviderMock());
  locator.registerSingleton<LocationProvider>(LocationProviderMock());
  locator.registerSingleton<FirestoreProvider>(FirestoreProviderMock());
  locator.registerSingleton<CurrentUserData>(CurrentUserData());
}

void resetLocator() {
  locator.unregister<AuthenticationProvider>();
  locator.unregister<LocationProvider>();
  locator.unregister<FirestoreProvider>();
  locator.unregister<CurrentUserData>();
}
