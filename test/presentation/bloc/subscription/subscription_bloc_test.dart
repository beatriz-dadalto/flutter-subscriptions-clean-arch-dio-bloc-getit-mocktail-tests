import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/core/errors/failures.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/subscription.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/usecases/get_subscription_by_slug.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/usecases/get_subscriptions.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_event.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSubscriptions extends Mock implements GetSubscriptions {}

class MockGetSubscriptionBySlug extends Mock implements GetSubscriptionBySlug {}

void main() {
  late GetSubscriptions getSubscriptions;
  late GetSubscriptionBySlug getSubscriptionBySlug;
  late SubscriptionBloc bloc;

  setUp(() {
    getSubscriptions = MockGetSubscriptions();
    getSubscriptionBySlug = MockGetSubscriptionBySlug();
    bloc = SubscriptionBloc(
      getSubscriptions: getSubscriptions,
      getSubscriptionBySlug: getSubscriptionBySlug,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final testSubscriptions = [
    Subscription.fake(slug: 'sub-1', name: 'Assinatura 1'),
    Subscription.fake(slug: 'sub-2', name: 'Assinatura 2'),
  ];

  final testSubscription = Subscription.fake(
    slug: 'empiricus-investidor',
    name: 'Empiricus Investidor',
  );

  group('SubscriptionBloc', () {
    test('initial state should be SubscriptionInitial', () {
      expect(bloc.state, equals(const SubscriptionInitial()));
    });

    group('LoadSubscriptions', () {
      blocTest<SubscriptionBloc, SubscriptionState>(
        'emits [SubscriptionLoading, SubscriptionLoaded] when successful',
        build: () {
          when(
            () => getSubscriptions(),
          ).thenAnswer((_) async => Right(testSubscriptions));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadSubscriptions()),
        expect: () => [
          const SubscriptionLoading(),
          SubscriptionLoaded(testSubscriptions),
        ],
        verify: (_) {
          verify(() => getSubscriptions()).called(1);
        },
      );

      blocTest<SubscriptionBloc, SubscriptionState>(
        'emits [SubscriptionLoading, SubscriptionError] when ServerFailure',
        build: () {
          when(() => getSubscriptions()).thenAnswer(
            (_) async => Left(ServerFailure(message: 'Erro no servidor')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadSubscriptions()),
        expect: () => [const SubscriptionLoading(), isA<SubscriptionError>()],
      );

      blocTest<SubscriptionBloc, SubscriptionState>(
        'emits [SubscriptionLoading, SubscriptionLoaded] with empty list',
        build: () {
          when(
            () => getSubscriptions(),
          ).thenAnswer((_) async => const Right([]));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadSubscriptions()),
        expect: () => [
          const SubscriptionLoading(),
          const SubscriptionLoaded([]),
        ],
      );
    });

    group('LoadSubscriptionDetail', () {
      blocTest<SubscriptionBloc, SubscriptionState>(
        'emits [SubscriptionLoading, SubscriptionDetailLoaded] when successful',
        build: () {
          when(
            () => getSubscriptionBySlug('empiricus-investidor'),
          ).thenAnswer((_) async => Right(testSubscription));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoadSubscriptionDetail(slug: 'empiricus-investidor'),
        ),
        expect: () => [
          const SubscriptionLoading(),
          SubscriptionDetailLoaded(testSubscription),
        ],
        verify: (_) {
          verify(() => getSubscriptionBySlug('empiricus-investidor')).called(1);
        },
      );

      blocTest<SubscriptionBloc, SubscriptionState>(
        'emits [SubscriptionLoading, SubscriptionError] when NotFoundFailure',
        build: () {
          when(
            () => getSubscriptionBySlug(any()),
          ).thenAnswer((_) async => const Left(NotFoundFailure()));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const LoadSubscriptionDetail(slug: 'non-existent')),
        expect: () => [const SubscriptionLoading(), isA<SubscriptionError>()],
      );
    });

    group('RefreshSubscriptions', () {
      blocTest<SubscriptionBloc, SubscriptionState>(
        'emits [SubscriptionLoaded] without Loading state (for better UX)',
        build: () {
          when(
            () => getSubscriptions(),
          ).thenAnswer((_) async => Right(testSubscriptions));
          return bloc;
        },
        act: (bloc) => bloc.add(const RefreshSubscriptions()),
        expect: () => [SubscriptionLoaded(testSubscriptions)],
      );
    });
  });
}
