import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:get/route_manager.dart';

class AuthBlocHelpers {
  static void showFailureSnackbar(AuthFailure state) => Get.rawSnackbar(
      title: 'Authentication failure',
      message: state.message,
      snackPosition: SnackPosition.BOTTOM);

  static void showErrorSnackbar(AuthError state) => Get.rawSnackbar(
      title: 'Error occured',
      message: state.message ?? 'Please try again.',
      snackPosition: SnackPosition.BOTTOM);
}
