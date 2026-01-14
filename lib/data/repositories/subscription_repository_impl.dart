import 'package:fpdart/fpdart.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/types/result_types.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository_interface.dart';
import '../data_sources/subscription_remote_data_source.dart';

/// Implementation of the [SubscriptionRepository] interface.
///
/// This class is responsible for:
/// - Fetching data from remote data sources.
/// - Converting data models ([SubscriptionModel]) into domain entities ([Subscription]).
/// - Handling exceptions from data sources and mapping them to appropriate [Failure] types.
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource _remoteDataSource;
  // final SubscriptionLocalDataSource _localDataSource;

  const SubscriptionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Subscription>>> getSubscriptions() async {
    try {
      final subscriptionModels = await _remoteDataSource.getSubscriptions();
      return Right(
        subscriptionModels.map((model) => model.toEntity()).toList(),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on ParseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Subscription>> getSubscriptionBySlug(String slug) async {
    try {
      final subscriptionModels = await _remoteDataSource.getSubscriptions();
      final subscriptionModel = subscriptionModels.firstWhere(
        (model) => model.identifier.slug == slug,
      );
      return Right(subscriptionModel.toEntity());
    } on StateError {
      return Left(NotFoundFailure(message: 'Assinatura não encontrada.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on ParseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
