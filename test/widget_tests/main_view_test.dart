import 'package:Dating_app/data/data_providers/authentication_provider.dart';
import 'package:Dating_app/data/data_providers/firestore_provider.dart';
import 'package:Dating_app/data/data_providers/location_provider.dart';
import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/discovery_settings.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/authentication_repository.dart';
import 'package:Dating_app/data/repositories/location_repository.dart';
import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/logic/dicovery_bloc/discovery_bloc.dart';
import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/universal_components/user_profile_item/user_profile_item.dart';
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

class PhotosRepositoryMock extends Mock implements PhotosRepository {}

class AuthBlocMock extends Mock implements AuthBloc {}

// class CurrentUserCubitMock extends Mock implements CurrentUserCubit {}
class CurrentUserCubitMock extends CurrentUserCubit {
  CurrentUserCubitMock(
      UsersRepository usersRepository,
      AuthenticationRepository authRepository,
      LocationRepository locationRepository)
      : super(usersRepository, authRepository, locationRepository);

  @override
  Future<void> updateUser({User updatedUser, User oldUser}) {}

  @override
  Future<void> updateDiscoverySettings(
      User user, DiscoverySettings discoverySettings) {}

  @override
  Future<void> getCurrentLocation() {}

  @override
  Future<void> checkIfProfileIsComplete() {}
}

class PhotosCubitMock extends PhotosCubit {
  PhotosCubitMock(PhotosRepository photosRepository) : super(photosRepository);

  @override
  Future<void> getMultiplePhotosUrls(String userId) {}
}

class DiscoveryBlocMock extends DiscoveryBloc {
  DiscoveryBlocMock(UsersRepository usersRepository) : super(usersRepository);

  @override
  void add(DiscoveryEvent event) {}
}

void main() {
  group('MainViewTest -', () {
    UsersRepository usersRepository;
    AuthenticationRepository authRepository;
    LocationRepository locationRepository;
    PhotosRepository photosRepository;
    AuthBloc authBloc;
    CurrentUserCubit currentUserCubit;
    DiscoveryBloc discoveryBloc;
    PhotosCubit photosCubit;

    setUp(() {
      Get.testMode = true; // for Get navigation testing

      setupLocator();

      usersRepository = UsersRepositoryMock();
      authRepository = AuthenticationRepositoryMock();
      locationRepository = LocationRepositoryMock();
      photosRepository = PhotosRepositoryMock();

      authBloc = AuthBloc(authRepository);
      currentUserCubit = CurrentUserCubitMock(
          usersRepository, authRepository, locationRepository);
      discoveryBloc = DiscoveryBlocMock(usersRepository);
      photosCubit = PhotosCubitMock(photosRepository);
    });
    tearDown(() {
      resetLocator();
    });

    testWidgets('When first started, view shows loading spinner',
        (tester) async {
      await _pumpViewWithBlocProviders(
          tester, authBloc, currentUserCubit, discoveryBloc, photosCubit);

      expect(find.byType(LoadingSpinner), findsOneWidget);
    });
    testWidgets('When first started, current shown tab is Discovery View',
        (tester) async {
      await _pumpViewWithBlocProviders(
          tester, authBloc, currentUserCubit, discoveryBloc, photosCubit);

      expect(find.byType(DiscoveryView), findsOneWidget);
      expect(find.byType(ConversationsMatchesView), findsNothing);
      expect(find.byType(MyProfileView), findsNothing);
    });

    group('DiscoveryView -', () {
      testWidgets(
          'When user profie is incomplete (missing personal data), navigates to ProfileCreationView',
          (tester) async {
        await _pumpViewWithBlocProviders(
            tester, authBloc, currentUserCubit, discoveryBloc, photosCubit);

        currentUserCubit.emit(CurrentUserProfileIncomplete(
            user: null, profileStatus: ProfileStatus.MissingPersonalData));

        await tester.pumpAndSettle();

        expect(find.byType(ProfileCreationView), findsOneWidget);
        expect(find.byType(DiscoveryView), findsNothing);
      });
      testWidgets(
          'When user profie is incomplete (missing discovery settings), navigates to DiscoverySettingsView',
          (tester) async {
        await _pumpViewWithBlocProviders(
            tester, authBloc, currentUserCubit, discoveryBloc, photosCubit);

        currentUserCubit.emit(CurrentUserProfileIncomplete(
            user: _userMissingDiscoverySettings,
            profileStatus: ProfileStatus.MissingDiscoverySettings));

        await tester.pumpAndSettle();

        expect(find.byType(DiscoverySettingsView), findsOneWidget);
        expect(find.byType(DiscoveryView), findsNothing);
      });

      group('When user profile is complete -', () {
        testWidgets(
            'When users for DiscoveryBloc are not fetched, shows loading spinner',
            (tester) async {
          await _pumpViewWithBlocProviders(
              tester, authBloc, currentUserCubit, discoveryBloc, photosCubit);

          currentUserCubit.emit(CurrentUserReady(_user));
          discoveryBloc.emit(DiscoveryWaiting());

          await tester.pump();

          expect(
              find.byKey(ValueKey('DiscoveryLoadingSpinner')), findsOneWidget);
        });
        testWidgets(
            'When users for DiscoveryBloc are fetched, shows profile of first user',
            (tester) async {
          await _pumpViewWithBlocProviders(
              tester, authBloc, currentUserCubit, discoveryBloc, photosCubit);

          currentUserCubit.emit(CurrentUserReady(_user));
          discoveryBloc.emit(DiscoveryUsersFetched(_usersFetched));

          await tester.pump();

          expect(find.byKey(ValueKey(_usersFetched.first.id)), findsOneWidget);
          expect(find.byType(UserProfileItem), findsOneWidget);
        });
      });
    });
  });
}

Future<void> _pumpViewWithBlocProviders(
    WidgetTester tester,
    AuthBloc authBloc,
    CurrentUserCubit currentUserCubit,
    DiscoveryBloc discoveryBloc,
    PhotosCubit photosCubit) async {
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<CurrentUserCubit>.value(value: currentUserCubit),
        BlocProvider<DiscoveryBloc>.value(value: discoveryBloc),
        BlocProvider<PhotosCubit>.value(value: photosCubit),
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

final _user = User(
  id: '1',
  name: 'Chad',
  birthDate: DateTime(1995, 01, 01),
  gender: Gender.Man,
  caption: 'Im Chad',
  discoverySettings: DiscoverySettings(
    gender: Gender.Woman,
    ageMin: 23,
    ageMax: 30,
    distance: 40,
  ),
  location: CustomLocation(latitude: 100, longitude: -100),
);

final _usersFetched = [
  User(
      id: 'F1',
      name: 'Stacy',
      birthDate: DateTime(1990, 01, 01),
      gender: Gender.Woman,
      location: CustomLocation(latitude: 100, longitude: -100)),
  User(
      id: 'F2',
      name: 'Lucy',
      birthDate: DateTime(1990, 01, 01),
      gender: Gender.Woman,
      location: CustomLocation(latitude: 100, longitude: -100)),
  User(
      id: 'F3',
      name: 'Anna',
      birthDate: DateTime(1990, 01, 01),
      gender: Gender.Woman,
      location: CustomLocation(latitude: 100, longitude: -100)),
];

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
