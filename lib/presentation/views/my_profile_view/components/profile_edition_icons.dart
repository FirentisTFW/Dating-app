import 'package:Dating_app/presentation/views/caption_edition_view/caption_edition_view.dart';
import 'package:Dating_app/presentation/views/discovery_settings_view/discovery_settings_view.dart';
import 'package:Dating_app/presentation/views/my_photos_view/my_photos_view.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ProfileEditionIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          const Expanded(flex: 3, child: SizedBox()),
          Flexible(
            child: IconButton(
              onPressed: goToCaptionEditionView,
              icon: const Icon(Icons.edit),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
          Flexible(
            child: IconButton(
              onPressed: goToMyPhotosView,
              icon: const Icon(Icons.photo_library_rounded),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
          Flexible(
            child: IconButton(
              onPressed: goToDiscoverySettingsView,
              icon: const Icon(Icons.person_search),
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
}
