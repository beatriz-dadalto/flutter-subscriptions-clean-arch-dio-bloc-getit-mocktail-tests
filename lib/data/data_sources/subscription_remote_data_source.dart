import '../../core/errors/exceptions.dart';
import '../../core/network/api_client_interface.dart';
import '../models/subscription_model.dart';

/// Abstract contract for the remote data source of subscriptions.
///
/// This interface defines the operations for fetching subscription data
/// from a remote API, abstracting the underlying network implementation.
abstract class SubscriptionRemoteDataSource {
  /// Fetches a list of [SubscriptionModel]s from the remote API.
  ///
  /// Throws [NetworkException] for connectivity issues, [ServerException]
  /// for API errors, or [ParseException] if the response format is invalid.
  Future<List<SubscriptionModel>> getSubscriptions();
}

/// Implementation of the remote data source for subscriptions using [ApiClient].
///
/// This class is responsible for making actual HTTP requests to the API
/// and parsing the responses into [SubscriptionModel] objects. It handles
/// network and server exceptions by rethrowing them or converting generic
/// errors into [ServerException] or [ParseException].
class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final ApiClient _apiClient;

  /// Creates a [SubscriptionRemoteDataSourceImpl] with a required [ApiClient].
  const SubscriptionRemoteDataSourceImpl(this._apiClient);

  /// Fetches a list of [SubscriptionModel]s from the remote API.
  ///
  /// Delegates the HTTP GET request to the [_apiClient] and then parses
  /// the received data.
  /// Throws [NetworkException], [ServerException], or [ParseException]
  /// on various error conditions.
  @override
  Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      final response = await _apiClient.get('/list.json');

      return _parseResponse(response.data);
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Erro ao buscar dados: $e');
    }
  }

  /// Parses the API response data into a list of [SubscriptionModel]s.
  ///
  /// Expects the data to be a Map containing a 'groups' list.
  /// Throws [ServerException] if the response format is invalid or
  /// [ParseException] if individual subscription items cannot be parsed.
  List<SubscriptionModel> _parseResponse(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const ServerException(message: 'Formato de resposta inválido');
    }

    final groups = data['groups'];
    if (groups is! List) {
      throw const ServerException(
        message: 'Campo "groups" não encontrado ou inválido',
      );
    }

    if (groups.isEmpty) {
      return const [];
    }

    try {
      return groups
          .cast<Map<String, dynamic>>()
          .map(SubscriptionModel.fromJson)
          .toList(growable: false);
    } catch (e) {
      throw ParseException('Erro ao parsear assinaturas: $e');
    }
  }
}
