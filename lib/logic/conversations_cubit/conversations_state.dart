part of 'conversations_cubit.dart';

abstract class ConversationsState extends Equatable {
  const ConversationsState();

  @override
  List<Object> get props => [];
}

class ConversationsInitial extends ConversationsState {}

class ConversationsWaiting extends ConversationsState {}

class ConversationsConversationCreated extends ConversationsState {}

class ConversationsFetched extends ConversationsState {
  final List<ConversationOverview> conversations;

  const ConversationsFetched(this.conversations);

  @override
  List<Object> get props => [conversations];
}

class ConversationsError extends ConversationsState {
  final String message;

  const ConversationsError({this.message});

  @override
  List<Object> get props => [message];
}
