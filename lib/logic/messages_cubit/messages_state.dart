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

  const MessagesReferenceFetched(this.messagesReference);

  @override
  List<Object> get props => [messagesReference];
}

abstract class MessagesFailure extends MessagesState {
  final String message;

  const MessagesFailure({this.message});

  @override
  List<Object> get props => [message];
}

class MessagesFailureFetching extends MessagesFailure {
  const MessagesFailureFetching({message}) : super(message: message);
}

class MessagesFailureSending extends MessagesFailure {
  const MessagesFailureSending({message}) : super(message: message);
}
