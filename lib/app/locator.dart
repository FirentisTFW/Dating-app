import 'package:Dating_app/data/data_providers/authentication_provider.dart';
import 'package:Dating_app/data/data_providers/firestore_provider.dart';
import 'package:Dating_app/data/data_providers/firebase_storage_provider.dart';
import 'package:Dating_app/data/data_providers/location_provider.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<FirestoreProvider>(() => FirestoreProvider());
  locator.registerLazySingleton<AuthenticationProvider>(
      () => AuthenticationProvider());
  locator.registerLazySingleton<FirebaseStorageProvider>(
      () => FirebaseStorageProvider());
  locator.registerLazySingleton<LocationProvider>(() => LocationProvider());
}
