import 'package:get_it/get_it.dart';

import '../../data/data_sources/subscription_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../../domain/repositories/subscription_repository_interface.dart';
import '../../domain/usecases/get_subscription_by_slug.dart';
import '../../domain/usecases/get_subscriptions.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/subscription/subscription_bloc.dart';
import '../network/api_client_interface.dart';
import '../network/dio_api_client_impl.dart';

/// Global instance of [GetIt] for dependency injection.
///
/// This instance is used throughout the application to retrieve registered
/// dependencies.
final GetIt getIt = GetIt.instance;

/// Configures all application dependencies using [GetIt].
///
/// This asynchronous function registers various components across different
/// layers of the application (Core, Data, Domain, Presentation) as singletons
/// or factories, making them available for injection.
Future<void> configureDependencies() async {
  // ═══════════════════════════════════════════════════════════════════════════
  // CORE LAYER
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<ApiClient>(() => DioApiClient());

  // ═══════════════════════════════════════════════════════════════════════════
  // DATA LAYER
  // ═══════════════════════════════════════════════════════════════════════════

  // Data Sources
  getIt.registerLazySingleton<SubscriptionRemoteDataSource>(
    () => SubscriptionRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(getIt<SubscriptionRemoteDataSource>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DOMAIN LAYER
  // ═══════════════════════════════════════════════════════════════════════════

  // Use Cases
  getIt.registerLazySingleton<GetSubscriptions>(
    () => GetSubscriptions(getIt<SubscriptionRepository>()),
  );

  getIt.registerLazySingleton<GetSubscriptionBySlug>(
    () => GetSubscriptionBySlug(getIt<SubscriptionRepository>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // PRESENTATION LAYER
  // ═══════════════════════════════════════════════════════════════════════════

  /// Registers [AuthBloc] as a lazy singleton.
  /// It manages the authentication state globally and is not disposed.
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      getIt<LoginUseCase>(),
      getIt<LogoutUseCase>(),
      getIt<AuthRepository>(),
    ),
  );

  /// Registers [SubscriptionBloc] as a factory.
  /// A new instance is created each time it's requested, suitable for per-screen usage.
  getIt.registerFactory<SubscriptionBloc>(
    () => SubscriptionBloc(
      getSubscriptions: getIt<GetSubscriptions>(),
      getSubscriptionBySlug: getIt<GetSubscriptionBySlug>(),
    ),
  );
}
