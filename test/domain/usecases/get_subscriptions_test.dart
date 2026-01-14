import 'package:empiricus_app_dev_beatriz_dadalto/core/errors/failures.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/subscription.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/repositories/subscription_repository_interface.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/usecases/get_subscriptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_subscription_repository.dart';

// 1. What does the class depend on?
// Answer: SubscriptionRepository
// 2. How can we create a fake version of the dependency?
// Answer: Use Mocktail
// 3. How do we control what our dependencies do?
// Answer: Using Mocktail's APIs (when, thenAnswer, verify)

void main() {
  late SubscriptionRepository repository;
  late GetSubscriptions usecase;

  // setUp runs before each test
  setUp(() {
    repository = MockSubscriptionRepository();
    usecase = GetSubscriptions(repository);
  });

  group('GetSubscriptions', () {
    // Test data
    final testSubscriptions = [
      Subscription.fake(slug: 'sub-1', name: 'Assinatura 1'),
      Subscription.fake(slug: 'sub-2', name: 'Assinatura 2'),
    ];

    test(
      'should return List<Subscription> when repository call is successful',
      () async {
        // Arrange - setup mock behavior
        when(
          () => repository.getSubscriptions(),
        ).thenAnswer((_) async => Right(testSubscriptions));

        // Act - execute the usecase
        final result = await usecase();

        // Assert - verify the result
        expect(
          result,
          equals(Right<Failure, List<Subscription>>(testSubscriptions)),
        );

        // Verify repository was called exactly once
        verify(() => repository.getSubscriptions()).called(1);

        // Verify no other interactions with the mock
        verifyNoMoreInteractions(repository);
      },
    );

    test(
      'should return ServerFailure when repository throws server error',
      () async {
        // Arrange
        final failure = ServerFailure(message: 'Erro no servidor');
        when(
          () => repository.getSubscriptions(),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await usecase();

        // Assert
        expect(
          result,
          equals(Left<Failure, List<Subscription>>(failure)),
        );
        verify(() => repository.getSubscriptions()).called(1);
        verifyNoMoreInteractions(repository);
      },
    );

    test('should return empty list when no subscriptions exist', () async {
      // Arrange
      when(
        () => repository.getSubscriptions(),
      ).thenAnswer((_) async => const Right([]));

      // Act
      final result = await usecase();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should be success'),
        (subscriptions) => expect(subscriptions, isEmpty),
      );
      verify(() => repository.getSubscriptions()).called(1);
    });
  });
}
