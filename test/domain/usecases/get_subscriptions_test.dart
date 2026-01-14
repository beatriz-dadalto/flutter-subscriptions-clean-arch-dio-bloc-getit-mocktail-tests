import 'package:empiricus_app_dev_beatriz_dadalto/core/errors/failures.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/subscription.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/repositories/subscription_repository_interface.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/usecases/get_subscriptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_subscription_repository.dart';

void main() {
  late SubscriptionRepository repository;
  late GetSubscriptions usecase;

  setUp(() {
    repository = MockSubscriptionRepository();
    usecase = GetSubscriptions(repository);
  });

  group('GetSubscriptions', () {
    final testSubscriptions = [
      Subscription.fake(slug: 'sub-1', name: 'Assinatura 1'),
      Subscription.fake(slug: 'sub-2', name: 'Assinatura 2'),
    ];

    test(
      'should return List<Subscription> when repository call is successful',
      () async {
        when(
          () => repository.getSubscriptions(),
        ).thenAnswer((_) async => Right(testSubscriptions));

        final result = await usecase();

        expect(
          result,
          equals(Right<Failure, List<Subscription>>(testSubscriptions)),
        );

        verify(() => repository.getSubscriptions()).called(1);

        verifyNoMoreInteractions(repository);
      },
    );

    test(
      'should return ServerFailure when repository throws server error',
      () async {
        final failure = ServerFailure(message: 'Erro no servidor');
        when(
          () => repository.getSubscriptions(),
        ).thenAnswer((_) async => Left(failure));

        final result = await usecase();

        expect(result, equals(Left<Failure, List<Subscription>>(failure)));
        verify(() => repository.getSubscriptions()).called(1);
        verifyNoMoreInteractions(repository);
      },
    );

    test('should return empty list when no subscriptions exist', () async {
      when(
        () => repository.getSubscriptions(),
      ).thenAnswer((_) async => const Right([]));

      final result = await usecase();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should be success'),
        (subscriptions) => expect(subscriptions, isEmpty),
      );
      verify(() => repository.getSubscriptions()).called(1);
    });
  });
}
