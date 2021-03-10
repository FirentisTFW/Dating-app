import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/user.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class CaptionEditionView extends StatefulWidget {
  const CaptionEditionView({Key key}) : super(key: key);

  @override
  _CaptionEditionViewState createState() => _CaptionEditionViewState();
}

class _CaptionEditionViewState extends State<CaptionEditionView> {
  TextEditingController captionController;
  User user;

  @override
  void initState() {
    super.initState();

    final userData = locator<CurrentUserData>();
    user = userData.user;
    captionController = TextEditingController(text: user.caption);
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Caption'),
        actions: [
          BlocConsumer<CurrentUserCubit, CurrentUserState>(
            listener: (context, state) {
              if (state is CurrentUserReady) {
                Get.back();
              } else if (state is CurrentUserFailure) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(state.message ?? 'Try again')));
              }
            },
            builder: (context, state) {
              if (state is CurrentUserWaiting) {
                return LoadingSpinner();
              } else {
                return FlatButton(
                  padding: const EdgeInsets.only(right: 10),
                  onPressed: submitCaption,
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: captionController,
          maxLines: 12,
          minLines: 6,
        ),
      ),
    );
  }

  void submitCaption() {
    final updatedUser = user.copyWith(caption: captionController.text);

    BlocProvider.of<CurrentUserCubit>(context)
        .updateUser(updatedUser: updatedUser, oldUser: user);
  }
}
