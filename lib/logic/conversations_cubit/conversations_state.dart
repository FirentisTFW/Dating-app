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

abstract class ConversationsFailure extends ConversationsState {
  final String message;

  const ConversationsFailure({this.message});

  @override
  List<Object> get props => [message];
}

class ConversationsFetchingFailure extends ConversationsFailure {
  const ConversationsFetchingFailure({String message})
      : super(message: message);
}

class ConversationsCreatingFailure extends ConversationsFailure {
  const ConversationsCreatingFailure({String message})
      : super(message: message);
}
