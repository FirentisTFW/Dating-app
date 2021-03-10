import 'dart:math';

import 'package:Dating_app/app/locator.dart';
import 'package:Dating_app/data/models/user_match.dart';
import 'package:Dating_app/logic/current_user_data.dart';
import 'package:Dating_app/logic/matches_cubit/matches_cubit.dart';
import 'package:Dating_app/presentation/helpers/snackbar_helpers.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/match_item.dart';

class MatchesView extends StatelessWidget {
  MatchesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _fetchMatches(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 6),
      child: BlocConsumer<MatchesCubit, MatchesState>(
        listener: (context, state) {
          if (state is MatchesException) {
            SnackbarHelpers.showFailureSnackbar(state.message);
          }
        },
        builder: (context, state) {
          if (state is MatchesFetched) {
            return ListView(
              children: _buildRows(state.matches),
            );
          }
          return LoadingSpinner();
        },
      ),
    );
  }

  List<Widget> _buildRows(List<UserMatch> matches) {
    List<Widget> rows = [];
    for (int i = 0; i < matches.length; i += 3) {
      List<UserMatch> rowMatches = [];
      for (int j = i; j < min(i + 3, matches.length); j++) {
        rowMatches.add(matches[j]);
      }

      rows.add(MatchRow(rowMatches));
      rows.add(const SizedBox(height: 20));
    }

    return rows;
  }

  void _fetchMatches(BuildContext context) {
    final userId = locator<CurrentUserData>().userId;

    BlocProvider.of<MatchesCubit>(context).fetchMatches(userId);
  }
}

class MatchRow extends StatelessWidget {
  final List<UserMatch> matches;

  const MatchRow(this.matches, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child: Row(
        children: _buildColumns(),
      ),
    );
  }

  List<Widget> _buildColumns() {
    List<Widget> columns = [const Expanded(child: SizedBox())];
    for (int i = 0; i < matches.length; i++) {
      columns.add(
          Flexible(flex: 2 * matches.length, child: MatchItem(matches[i])));
      columns.add(const Expanded(child: SizedBox()));
    }

    return columns;
  }

  // int _getColumnFlexSize(int columnsInRow) {
  //   return
  // }
}
