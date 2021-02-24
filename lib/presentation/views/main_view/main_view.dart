import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/conversations_matches_view/conversations_matches_view.dart';
import 'package:Dating_app/presentation/views/discovery_view/discovery_view.dart';
import 'package:Dating_app/presentation/views/my_profile_view/my_profile_view.dart';
import 'package:Dating_app/data/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainView extends StatefulWidget {
  MainView({Key key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var _currentTab = CurrentMainTab.Discovery;

  // TODO: find better way to check user profile completness
  var _startup = true;

  @override
  Widget build(BuildContext context) {
    if (_startup) {
      BlocProvider.of<CurrentUserCubit>(context).checkIfProfileIsComplete();
      _startup = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.account_circle, size: 28),
              onPressed: switchToProfileView,
            ),
            IconButton(
              icon: Icon(Icons.add_circle, size: 34),
              onPressed: switchToDiscoveryView,
            ),
            IconButton(
              icon: Icon(Icons.chat, size: 28),
              onPressed: switchToConversationsView,
            ),
          ],
        ),
      ),
      body: getViewForCurrentMainTab(),
    );
  }

  Widget getViewForCurrentMainTab() {
    switch (_currentTab) {
      case CurrentMainTab.MyProfile:
        return MyProfileView();
      case CurrentMainTab.Discovery:
        return DiscoveryView();
      case CurrentMainTab.ConversationsMatches:
        return ConversationsMatchesView();
      default:
        return LoadingSpinner();
    }
  }

  void switchToProfileView() =>
      setState(() => _currentTab = CurrentMainTab.MyProfile);

  void switchToDiscoveryView() =>
      setState(() => _currentTab = CurrentMainTab.Discovery);

  void switchToConversationsView() =>
      setState(() => _currentTab = CurrentMainTab.ConversationsMatches);
}
