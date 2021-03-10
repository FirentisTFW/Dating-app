import 'package:get/get.dart';

class SnackbarHelpers {
  static void showFailureSnackbar(String message, {String title}) =>
      Get.rawSnackbar(
          title: title ?? 'Try again',
          message: message ?? '',
          snackPosition: SnackPosition.BOTTOM);
}
