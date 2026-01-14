import 'package:empiricus_app_dev_beatriz_dadalto/core/errors/exceptions.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/core/errors/failures.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/data/data_sources/subscription_remote_data_source.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/data/models/identifier_model.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/data/models/subscription_model.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/data/repositories/subscription_repository_impl.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/repositories/subscription_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_subscription_remote_data_source.dart';

void main() {
  late SubscriptionRemoteDataSource remoteDataSource;
  late SubscriptionRepository repository;

  setUp(() {
    remoteDataSource = MockSubscriptionRemoteDataSource();
    repository = SubscriptionRepositoryImpl(remoteDataSource);
  });

  group('SubscriptionRepositoryImpl', () {
    // Test data - Models (como vem do DataSource)
    final testModels = [
      const SubscriptionModel(
        identifier: IdentifierModel(slug: 'sub-1'),
        name: 'Assinatura 1',
        shortDescription: 'Short 1',
        description: 'Description 1',
        imageLarge: 'https://example.com/large1.jpg',
        imageSmall: 'https://example.com/small1.jpg',
        authors: [],
        features: [],
      ),
      const SubscriptionModel(
        identifier: IdentifierModel(slug: 'sub-2'),
        name: 'Assinatura 2',
        shortDescription: 'Short 2',
        description: 'Description 2',
        imageLarge: 'https://example.com/large2.jpg',
        imageSmall: 'https://example.com/small2.jpg',
        authors: [],
        features: [],
      ),
    ];

    group('getSubscriptions', () {
      test(
        'should return List<Subscription> when datasource call is successful',
        () async {
          // Arrange
          when(
            () => remoteDataSource.getSubscriptions(),
          ).thenAnswer((_) async => testModels);

          // Act
          final result = await repository.getSubscriptions();

          // Assert
          expect(result.isRight(), true);
          result.fold((failure) => fail('Should be Right'), (subscriptions) {
            expect(subscriptions.length, 2);
            expect(subscriptions[0].slug, 'sub-1');
            expect(subscriptions[1].slug, 'sub-2');
          });
          verify(() => remoteDataSource.getSubscriptions()).called(1);
        },
      );

      test(
        'should return ServerFailure when ServerException is thrown',
        () async {
          // Arrange
          when(() => remoteDataSource.getSubscriptions()).thenThrow(
            const ServerException(message: 'Internal error', statusCode: 500),
          );

          // Act
          final result = await repository.getSubscriptions();

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ServerFailure>());
            expect((failure as ServerFailure).statusCode, 500);
          }, (_) => fail('Should be Left'));
        },
      );

      test(
        'should return ServerFailure when ParseException is thrown',
        () async {
          // Arrange
          when(
            () => remoteDataSource.getSubscriptions(),
          ).thenThrow(const ParseException('Invalid JSON'));

          // Act
          final result = await repository.getSubscriptions();

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, contains('Invalid JSON'));
          }, (_) => fail('Should be Left'));
        },
      );

      test('should return UnknownFailure for unexpected exceptions', () async {
        // Arrange
        when(
          () => remoteDataSource.getSubscriptions(),
        ).thenThrow(Exception('Unexpected'));

        // Act
        final result = await repository.getSubscriptions();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (_) => fail('Should be Left'),
        );
      });

      test('should return empty list when datasource returns empty', () async {
        // Arrange
        when(
          () => remoteDataSource.getSubscriptions(),
        ).thenAnswer((_) async => []);

        // Act
        final result = await repository.getSubscriptions();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (subscriptions) => expect(subscriptions, isEmpty),
        );
      });
    });

    group('getSubscriptionBySlug', () {
      test('should return Subscription when found by slug', () async {
        // Arrange
        when(
          () => remoteDataSource.getSubscriptions(),
        ).thenAnswer((_) async => testModels);

        // Act
        final result = await repository.getSubscriptionBySlug('sub-1');

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should be Right'), (subscription) {
          expect(subscription.slug, 'sub-1');
          expect(subscription.name, 'Assinatura 1');
        });
      });

      test('should return NotFoundFailure when slug not found', () async {
        // Arrange
        when(
          () => remoteDataSource.getSubscriptions(),
        ).thenAnswer((_) async => testModels);

        // Act
        final result = await repository.getSubscriptionBySlug('non-existent');

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<NotFoundFailure>());
          expect(failure.message, contains('Assinatura não encontrada.'));
        }, (_) => fail('Should be Left'));
      });
    });
  });
}
