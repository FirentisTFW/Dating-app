import 'dart:math';

import 'package:Dating_app/data/models/user_match.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/logic/custom_helpers.dart';
import 'package:Dating_app/logic/matches_cubit/matches_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchesView extends StatelessWidget {
  MatchesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: find better way to get userId

    final currentUserState = BlocProvider.of<CurrentUserCubit>(context).state
        as CurrentUserWithUserInstance;
    final userId = currentUserState.user.id;
    BlocProvider.of<MatchesCubit>(context).fetchMatches(userId);

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: BlocConsumer<MatchesCubit, MatchesState>(
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

class MatchItem extends StatelessWidget {
  final UserMatch match;

  const MatchItem(this.match, {Key key}) : super(key: key);

  // final match = Match(
  //   userId: 'wasdsa1',
  //   name: 'Hannah',
  //   birthDate: DateTime(1997, 04, 09),
  //   matchDate: DateTime(2021, 02, 18),
  // );

  final photoUrl =
      'https://firebasestorage.googleapis.com/v0/b/dating-app-76b0f.appspot.com/o/users_images%2FmgIzISF1o6Gfau0SqV1arDCZNtKO2%2F1613388447806?alt=media&token=24ffe37b-1b3d-4346-80a2-cc08b859ad35';

  @override
  Widget build(BuildContext context) {
    final age =
        CustomHelpers.getDifferenceInYears(match.birthDate, DateTime.now());
    return Expanded(
      flex: 6,
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          height: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.network(
                    photoUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 0, 8),
                  child: Text(
                    '${match.name},  ${age.toString()}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
