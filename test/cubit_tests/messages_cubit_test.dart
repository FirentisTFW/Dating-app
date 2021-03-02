import 'package:Dating_app/data/models/message.dart';
import 'package:Dating_app/data/repositories/conversations_repository.dart';
import 'package:Dating_app/logic/messages_cubit/messages_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ConversationsRepositoryMock extends Mock
    implements ConversationsRepository {}

void main() {
  ConversationsRepositoryMock conversationsRepository;
  final exceptionMessage = 'An error occured';
  group('MessagesCubitTest -', () {
    setUp(() {
      conversationsRepository = ConversationsRepositoryMock();
    });
    group('getMessagesRef -', () {
      blocTest('When failure, emits [MessagesWaiting, MessagesErrorFetching]',
          build: () {
            when(conversationsRepository.getMessagesRef(any))
                .thenThrow(Exception(exceptionMessage));
            return MessagesCubit(conversationsRepository);
          },
          act: (cubit) => cubit.getMessagesRef('conversationId'),
          expect: [
            MessagesWaiting(),
            MessagesErrorFetching(),
          ]);
    });
    group('sendMessage -', () {
      final message =
          Message(content: 'Hi', date: DateTime(2021, 02, 12), userId: 'abc');

      blocTest(
          'When failure and conversaions were not fetched before, emits [MessagesErrorSending]',
          build: () {
            when(conversationsRepository.sendMessage(any, any))
                .thenThrow(Exception(exceptionMessage));
            return MessagesCubit(conversationsRepository);
          },
          act: (cubit) => cubit.sendMessage('conversationId', message),
          expect: [MessagesErrorSending()]);
    });
  });
}
