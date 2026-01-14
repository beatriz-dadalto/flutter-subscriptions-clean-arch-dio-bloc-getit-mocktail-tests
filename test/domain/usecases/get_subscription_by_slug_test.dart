import 'package:empiricus_app_dev_beatriz_dadalto/core/errors/failures.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/subscription.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/repositories/subscription_repository_interface.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/usecases/get_subscription_by_slug.dart';
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
  late GetSubscriptionBySlug usecase;

  // setUp runs before each test
  setUp(() {
    repository = MockSubscriptionRepository();
    usecase = GetSubscriptionBySlug(repository);
  });

  group('GetSubscriptionBySlug', () {
    // Test data
    const testSlug = 'empiricus-investidor';
    final testSubscription = Subscription.fake(
      slug: testSlug,
      name: 'Empiricus Investidor',
      description: 'Descrição do investidor',
    );

    test('should return Subscription when found by slug', () async {
      // Arrange
      when(
        () => repository.getSubscriptionBySlug(testSlug),
      ).thenAnswer((_) async => Right(testSubscription));

      // Act
      final result = await usecase(testSlug);

      // Assert
      expect(result, equals(Right<Failure, Subscription>(testSubscription)));
      verify(() => repository.getSubscriptionBySlug(testSlug)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return NotFoundFailure when subscription not found', () async {
      // Arrange
      const failure = NotFoundFailure();
      when(
        () => repository.getSubscriptionBySlug(testSlug),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(testSlug);

      // Assert
      expect(result, equals(const Left<Failure, Subscription>(failure)));
      verify(() => repository.getSubscriptionBySlug(testSlug)).called(1);
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      final failure = ServerFailure(message: 'Erro interno');
      when(
        () => repository.getSubscriptionBySlug(any()),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(testSlug);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Should be Left'),
      );
    });

    test('should call repository with correct slug parameter', () async {
      // Arrange
      const differentSlug = 'vacas-leiteiras';
      final differentSubscription = Subscription.fake(
        slug: differentSlug,
        name: 'Vacas Leiteiras',
      );
      when(
        () => repository.getSubscriptionBySlug(differentSlug),
      ).thenAnswer((_) async => Right(differentSubscription));

      // Act
      final result = await usecase(differentSlug);

      // Assert
      expect(result.isRight(), true);
      verify(() => repository.getSubscriptionBySlug(differentSlug)).called(1);
      verifyNever(() => repository.getSubscriptionBySlug(testSlug));
    });
  });
}
