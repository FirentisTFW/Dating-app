import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:get/route_manager.dart';

class CurrentUserCubitHelpers {
  static void showFailureSnackbar(CurrentUserFailure state) => Get.rawSnackbar(
        title: 'Error occured',
        message: state.message ?? 'Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
}
