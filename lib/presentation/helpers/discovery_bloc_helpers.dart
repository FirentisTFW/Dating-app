import 'package:Dating_app/logic/dicovery_bloc/discovery_bloc.dart';
import 'package:get/route_manager.dart';

class DiscoveryBlocHelpers {
  static void showErrorSnackbar(DiscoveryException state) => Get.rawSnackbar(
        title: 'An exception was thrown',
        message: state.message ?? 'Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
}
