import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/logic/photos_cubit/photos_cubit.dart';
import 'package:Dating_app/presentation/universal_components/user_profile_item/components/user_profile_item_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileItem extends StatelessWidget {
  final User user;
  final ProfileRelation profileRelation;
  final Function rejectUser;
  final Function acceptUser;

  UserProfileItem({
    Key key,
    @required this.user,
    this.profileRelation,
    this.rejectUser,
    this.acceptUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        BlocProvider.of<PhotosCubit>(context).getMultiplePhotosUrls(user.id);

        return Column(
          children: [
            PhotosSlider(),
            NameAgeLocationBar(
                user: user, isMine: profileRelation == ProfileRelation.Mine),
            Divider(color: Colors.grey[500]),
            buildCaption(),
            if (profileRelation == ProfileRelation.Discovered)
              buildMatchRejectBar(),
            if (profileRelation == ProfileRelation.Matched)
              buildMessageUnmatchBar(),
          ],
        );
      },
    );
  }

  Widget buildCaption() {
    return Expanded(
      flex: profileRelation == ProfileRelation.Discovered ? 3 : 2,
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
            GestureDetector(
              onTap: rejectUser,
              child: Icon(
                Icons.close,
                size: 38,
                color: Colors.red,
              ),
            ),
            GestureDetector(
              onTap: acceptUser,
              child: Icon(
                Icons.check,
                size: 38,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageUnmatchBar() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.message,
                  size: 38,
                  color: Colors.green,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.close,
                  size: 38,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
