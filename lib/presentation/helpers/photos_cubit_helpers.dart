import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:get/get.dart';

class PhotosCubitHelpers {
  static void showErrorSnackbar(PhotosError state) => Get.rawSnackbar(
        title: 'Error occured',
        message: state.message ?? 'Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
}
