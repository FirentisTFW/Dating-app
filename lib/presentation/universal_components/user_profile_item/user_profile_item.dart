import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/data/repositories/photos_repository.dart';
import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:Dating_app/presentation/universal_components/user_profile_item/components/user_profile_item_components.dart';
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
