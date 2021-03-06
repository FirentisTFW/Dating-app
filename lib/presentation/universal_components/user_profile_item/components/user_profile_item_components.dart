import 'package:Dating_app/data/models/custom_location.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:Dating_app/presentation/helpers/snackbar_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/my_profile_view/components/profile_edition_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotosSlider extends StatelessWidget {
  const PhotosSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 6,
      child: BlocConsumer<PhotosCubit, PhotosState>(
        listener: (ctx, state) {
          if (state is PhotosFailure) {
            SnackbarHelpers.showFailureSnackbar(state.message);
          }
        },
        builder: (ctx, state) {
          if (state is PhotosMultipleFetched) {
            return CarouselSlider(
              options: CarouselOptions(height: double.infinity),
              items: state.photosUrls.length > 0
                  ? buildUserPhotosForCarousel(context, state.photosUrls)
                  : buildSamplePhoto(context),
            );
          }
          return LoadingSpinner();
        },
      ),
    );
  }

  List<Widget> buildUserPhotosForCarousel(
      BuildContext context, List<String> photosUrls) {
    return photosUrls.map((item) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Image.network(
          item,
          fit: BoxFit.contain,
        ),
      );
    }).toList();
  }

  List<Widget> buildSamplePhoto(BuildContext context) {
    return [
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Image.asset(
          'assets/images/unknown_avatar.png',
          fit: BoxFit.contain,
        ),
      )
    ];
  }
}

class NameAgeLocationBar extends StatelessWidget {
  final User user;
  final bool isMine;

  const NameAgeLocationBar(
      {Key key, @required this.user, @required this.isMine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Theme(
        data: ThemeData(
            primaryColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.grey[600], size: 26)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${user.name}, ${user.getAge().toString()}',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            if (!isMine) _buildDistanceBox(),
            if (isMine) ProfileEditionIcons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceBox() => Expanded(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<CurrentUserCubit, CurrentUserState>(
                builder: (context, state) {
                  if (state is CurrentUserWithUserInstance) {
                    return Text(
                      getDistance(context, state.user.location, user.location)
                              .toStringAsFixed(2) +
                          ' kilometers away',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    );
                  }
                  return LoadingSpinner();
                },
              )),
        ),
      );

  double getDistance(BuildContext context, CustomLocation firstLocation,
      CustomLocation secondLocation) {
    return firstLocation.distance(
        lat: secondLocation.latitude, lng: secondLocation.longitude);
  }
}
