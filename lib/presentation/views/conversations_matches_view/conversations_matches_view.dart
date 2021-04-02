import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/helpers/snackbar_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/views/conversations_view/conversations_view.dart';
import 'package:Dating_app/presentation/views/matches_view/matches_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationsMatchesView extends StatefulWidget {
  ConversationsMatchesView({Key key}) : super(key: key);

  @override
  _ConversationsMatchesViewState createState() =>
      _ConversationsMatchesViewState();
}

class _ConversationsMatchesViewState extends State<ConversationsMatchesView> {
  var _currentSubTab = CurrentSubTab.Matches;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: switchToMatchesView,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'Matches',
                    style: TextStyle(
                      color: _currentSubTab == CurrentSubTab.Matches
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: switchToConversationsView,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'Conversations',
                    style: TextStyle(
                      color: _currentSubTab == CurrentSubTab.Conversations
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        BlocConsumer<CurrentUserCubit, CurrentUserState>(
          listener: (context, state) {
            if (state is CurrentUserFailure) {
              SnackbarHelpers.showFailureSnackbar(state.message);
            }
          },
          builder: (context, state) {
            if (state is CurrentUserReady) {
              return Expanded(
                child: _getViewForCurrentTab(),
              );
            }
            return Expanded(child: LoadingSpinner());
          },
        ),
      ],
    );
  }

  Widget _getViewForCurrentTab() {
    switch (_currentSubTab) {
      case CurrentSubTab.Matches:
        return MatchesView();
      case CurrentSubTab.Conversations:
        return ConversationsView();
      default:
        return LoadingSpinner();
    }
  }

  void switchToConversationsView() =>
      setState(() => _currentSubTab = CurrentSubTab.Conversations);

  void switchToMatchesView() =>
      setState(() => _currentSubTab = CurrentSubTab.Matches);
}
