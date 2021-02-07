import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:Dating_app/presentation/helpers/photos_cubit_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileItem extends StatelessWidget {
  final User user;
  final bool isMine;

  UserProfileItem({Key key, this.user, this.isMine = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotosCubit(PhotosRepository()),
      child: Builder(
        builder: (context) {
          BlocProvider.of<PhotosCubit>(context)
              .getMultiplePhotosUrls(user.id, user.photosRef);

          return Column(
            children: [
              PhotosSlider(),
              NameAgeLocationBar(user: user, isMine: isMine),
              Divider(color: Colors.grey[500]),
              buildCaption(),
              if (!isMine) buildMatchRejectBar(),
            ],
          );
        },
      ),
    );
  }

  Widget buildCaption() {
    return Expanded(
      flex: isMine ? 3 : 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Text(
              '${user.caption}',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMatchRejectBar() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.close,
              size: 38,
              color: Colors.red,
            ),
            Icon(
              Icons.check,
              size: 38,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class PhotosSlider extends StatelessWidget {
  const PhotosSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 6,
      child: BlocConsumer<PhotosCubit, PhotosState>(
        listener: (ctx, state) {
          if (state is PhotosError) {
            PhotosCubitHelpers.showErrorSnackbar(state);
          }
        },
        builder: (ctx, state) {
          if (state is PhotosMultipleFetched) {
            return CarouselSlider(
              options: CarouselOptions(height: double.infinity),
              items: state.photosUrls.map((item) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Image.network(
                    item,
                    fit: BoxFit.contain,
                  ),
                );
              }).toList(),
            );
          }
          return LoadingSpinner();
        },
      ),
    );
  }
}

class NameAgeLocationBar extends StatelessWidget {
  const NameAgeLocationBar(
      {Key key, @required this.user, @required this.isMine})
      : super(key: key);

  final User user;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
          if (!isMine)
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  // TODO: get real distance
                  child: Text('18 kilometers away',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
