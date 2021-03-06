import 'package:get/route_manager.dart';
import 'package:Dating_app/logic/conversations_cubit/conversations_cubit.dart';

class ConversationsCubitHelpers {
  static void showFailureSnackbar(ConversationsFailure state) =>
      Get.rawSnackbar(
        title: 'An Exception was thrown',
        message: state.message ?? 'Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
}
