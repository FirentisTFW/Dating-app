import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:Dating_app/presentation/views/caption_edition_view/caption_edition_view.dart';
import 'package:Dating_app/presentation/views/discovery_settings_view/discovery_settings_view.dart';
import 'package:Dating_app/presentation/views/my_photos_view/my_photos_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class ProfileEditionIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          const Expanded(flex: 3, child: SizedBox()),
          IconButton(
            onPressed: goToCaptionEditionView,
            icon: const Icon(Icons.edit),
          ),
          const Expanded(flex: 1, child: SizedBox()),
          IconButton(
            onPressed: goToMyPhotosView,
            icon: const Icon(Icons.photo_library_rounded),
          ),
          const Expanded(flex: 1, child: SizedBox()),
          IconButton(
            onPressed: goToDiscoverySettingsView,
            icon: const Icon(Icons.person_search),
          ),
          const Expanded(flex: 1, child: SizedBox()),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: () async => await showSignOutConfirmation(context),
            icon: const Icon(
              Icons.power_settings_new_rounded,
              size: 30,
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }

  void goToDiscoverySettingsView() => Get.to(DiscoverySettingsView());

  void goToMyPhotosView() => Get.to(MyPhotosView());

  void goToCaptionEditionView() => Get.to(CaptionEditionView());

  Future<void> showSignOutConfirmation(BuildContext context) async {
    await Get.defaultDialog(
        title: 'Do you want to sign out?',
        content: Container(),
        buttonColor: Theme.of(context).primaryColor,
        cancelTextColor: Theme.of(context).primaryColor,
        confirmTextColor: Colors.white,
        textConfirm: 'Yes',
        textCancel: 'No',
        onConfirm: () async {
          signOut(context);

          Get.back();
        });
  }

  void signOut(BuildContext context) =>
      BlocProvider.of<AuthBloc>(context).add(AuthSignOut());
}
