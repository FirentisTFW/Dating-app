part of 'messages_cubit.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

class MessagesInitial extends MessagesState {}

class MessagesWaiting extends MessagesState {}

class MessagesNewConversation extends MessagesState {}

class MessagesMessageSent extends MessagesState {}

class MessagesReferenceFetched extends MessagesState {
  final CollectionReference messagesReference;

  MessagesReferenceFetched(this.messagesReference);

  @override
  List<Object> get props => [messagesReference];
}

abstract class MessagesError extends MessagesState {
  final String errorMessage;

  MessagesError({this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class MessagesErrorFetching extends MessagesError {}

class MessagesErrorSending extends MessagesError {}
