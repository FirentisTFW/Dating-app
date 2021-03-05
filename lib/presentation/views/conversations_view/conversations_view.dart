import 'package:Dating_app/data/models/conversation_overview.dart';
import 'package:Dating_app/logic/conversations_cubit/conversations_cubit.dart';
import 'package:Dating_app/logic/current_user_cubit/current_user_cubit.dart';
import 'package:Dating_app/presentation/universal_components/loading_spinner.dart';
import 'package:Dating_app/presentation/universal_components/photo_icon.dart';
import 'package:Dating_app/presentation/views/chat_view/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import 'components/conversation_item.dart';

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
              if (state is ConversationsFetched) {
                return ConversationsList(state.conversations);
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

class ConversationsList extends StatelessWidget {
  final List<ConversationOverview> conversations;

  const ConversationsList(this.conversations);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () => goToConversation(conversations[index]),
        child: ConversationItem(conversations[index]),
      ),
    );
  }

  void goToConversation(ConversationOverview conversationOverview) => Get.to(
        ChatView(conversationOverview: conversationOverview),
      );
}
