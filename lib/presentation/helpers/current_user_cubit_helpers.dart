import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:get/route_manager.dart';

class CurrentUserCubitHelpers {
  static void showErrorSnackbar(CurrentUserError state) => Get.rawSnackbar(
        title: 'Error occured',
        message: state.message ?? 'Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
}
