import 'dart:math';

import 'package:Dating_app/data/models/user_match.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/matches_cubit/matches_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/match_item.dart';

class MatchesView extends StatelessWidget {
  MatchesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: BlocBuilder<CurrentUserCubit, CurrentUserState>(
          builder: (context, state) {
            if (state is CurrentUserWithUserInstance) {
              BlocProvider.of<MatchesCubit>(context)
                  .fetchMatches(state.user.id);

              return BlocConsumer<MatchesCubit, MatchesState>(
                listener: (context, state) {
                  if (state is MatchesError) {
                    print('Errorek taki potworek');
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
              );
            }
            return LoadingSpinner();
          },
        ),
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
      columns.add(MatchItem(matches[i]));
      columns.add(const Expanded(child: SizedBox()));
    }

    return columns;
  }
}
