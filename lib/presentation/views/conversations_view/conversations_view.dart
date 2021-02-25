import 'package:Dating_app/logic/conversations_cubit/conversations_cubit.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationsView extends StatelessWidget {
  const ConversationsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        if (state is CurrentUserWithUserInstance) {
          BlocProvider.of<ConversationsCubit>(context)
              .fetchConversations(state.user.id);
          return BlocConsumer<ConversationsCubit, ConversationsState>(
            listener: (context, state) {
              if (state is ConversationsError) {
                // TODO: react to error
              }
            },
            builder: (context, state) {
              print(state);
              if (state is ConversationsFetched) {
                print(state.conversations);
                return Container(
                  child: Text('fetched'),
                );
              }
              return LoadingSpinner();
            },
          );
        }
        return LoadingSpinner();
      },
    );
  }
}
