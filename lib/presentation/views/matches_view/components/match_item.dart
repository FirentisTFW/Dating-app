import 'package:Dating_app/data/models/user_match.dart';
import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:Dating_app/logic/custom_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/user_profile_view/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class MatchItem extends StatelessWidget {
  final UserMatch match;

  MatchItem(this.match, {Key key}) : super(key: key);

  // TODO: locator or smth
  final photosRepository = PhotosRepository();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: goToUserProfile,
      child: FutureBuilder(
        future: photosRepository.getFirstPhotoUrlForUser(match.userId),
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[300]),
            height: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (snapshot.connectionState == ConnectionState.waiting)
                  const LoadingSpinner(),
                if (snapshot.hasData) _buildPhoto(snapshot.data),
                if (snapshot.hasError) _buildPhoto(null),
                _buildNameAndAgeInfo(snapshot.hasData),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhoto(String photoUrl) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: FittedBox(
          fit: BoxFit.cover,
          child: photoUrl != null
              ? Image.network(
                  photoUrl,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  'assets/images/unknown_avatar.png',
                  fit: BoxFit.contain,
                ),
        ),
      );

  Widget _buildNameAndAgeInfo(bool isPhotoFetched) {
    final age =
        CustomHelpers.getDifferenceInYears(match.birthDate, DateTime.now());
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 0, 0, 8),
        child: Text(
          '${match.name},  ${age.toString()}',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  void goToUserProfile() => Get.to(UserProfileView(match.userId));
}
