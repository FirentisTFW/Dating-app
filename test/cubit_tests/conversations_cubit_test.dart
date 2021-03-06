import 'package:Dating_app/data/models/conversation_base.dart';
import 'package:Dating_app/data/models/conversation_overview.dart';
import 'package:Dating_app/data/models/message.dart';
import 'package:Dating_app/data/repositories/conversations_repository.dart';
import 'package:Dating_app/data/repositories/users_repository.dart';
import 'package:Dating_app/logic/conversations_cubit/conversations_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UsersRepositoryMock extends Mock implements UsersRepository {}

class ConversationsRepositoryMock extends Mock
    implements ConversationsRepository {}

void main() {
  group('ConversationsCubitTest -', () {
    UsersRepositoryMock usersRepository;
    ConversationsRepositoryMock conversationsRepository;

    final conversations = [
      ConversationOverview(
        conversationId: 'abcdef',
        userId: 'def',
        userName: 'Stacy',
        lastMessage: Message(
          content: 'Hi',
          date: DateTime(2021, 02, 02),
          userId: 'def',
        ),
      ),
      ConversationOverview(
        conversationId: 'abcrty',
        userId: 'rty',
        userName: 'Lucy',
        lastMessage: Message(
          content: 'Bye',
          date: DateTime(2021, 02, 02),
          userId: 'abc',
        ),
      ),
    ];
    final exceptionMessage = 'An error occured';

    setUp(() {
      usersRepository = UsersRepositoryMock();
      conversationsRepository = ConversationsRepositoryMock();
    });
    group('fetchConversations -', () {
      blocTest(
          'When successful, emits [ConversationsWaiting, ConversationsFetched]',
          build: () {
            when(usersRepository.getUserConversations(any))
                .thenAnswer((_) async => conversations);
            return ConversationsCubit(usersRepository, conversationsRepository);
          },
          act: (cubit) => cubit.fetchConversations('abc'),
          expect: [
            ConversationsWaiting(),
            ConversationsFetched(conversations),
          ]);
      blocTest(
          'When failure, emits [ConversationsWaiting, ConversationsFetchingFailure]',
          build: () {
            when(usersRepository.getUserConversations(any)).thenThrow(
                FirebaseException(plugin: 'plugin', message: exceptionMessage));
            return ConversationsCubit(usersRepository, conversationsRepository);
          },
          act: (cubit) => cubit.fetchConversations('abc'),
          expect: [
            ConversationsWaiting(),
            ConversationsFetchingFailure(message: exceptionMessage),
          ]);
    });
    group('createConversation -', () {
      final conversation = ConversationBase(
        conversationId: 'abcpoi',
        userIds: ['abc', 'poi'],
        date: DateTime(2021, 02, 12),
      );
      blocTest(
          'When successful and conversations were fetched before, emits [ConversationsWaiting, ConversationsConversationCreated, ConversationsFetched]',
          build: () {
        when(usersRepository.getUserConversations(any))
            .thenAnswer((_) async => conversations);
        when(conversationsRepository.createConversation(any))
            .thenAnswer((_) async => null);
        return ConversationsCubit(usersRepository, conversationsRepository);
      }, act: (cubit) async {
        await cubit.fetchConversations('abc');
        cubit.createConversation(conversation);
      }, skip: 2, expect: [
        ConversationsWaiting(),
        ConversationsConversationCreated(),
        ConversationsFetched(conversations),
      ]);
      blocTest(
          'When successful and conversations were not fetched before, emits [ConversationsWaiting, ConversationsConversationCreated, ConversationsInitial]',
          build: () {
            when(conversationsRepository.createConversation(any))
                .thenAnswer((_) async => null);
            return ConversationsCubit(usersRepository, conversationsRepository);
          },
          act: (cubit) => cubit.createConversation(conversation),
          expect: [
            ConversationsWaiting(),
            ConversationsConversationCreated(),
            ConversationsInitial(),
          ]);
      blocTest(
          'When failure, emits [ConversationsWaiting, ConversationsCreatingFailure]',
          build: () {
            when(conversationsRepository.createConversation(any)).thenThrow(
                FirebaseException(plugin: 'plugin', message: exceptionMessage));
            return ConversationsCubit(usersRepository, conversationsRepository);
          },
          act: (cubit) => cubit.createConversation(conversation),
          expect: [
            ConversationsWaiting(),
            ConversationsCreatingFailure(message: exceptionMessage),
          ]);
    });
  });
}
