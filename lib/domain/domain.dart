/// Domain Layer Exports
///
/// This barrel file re-exports all core components of the domain layer,
/// including entities, repository contracts, and use cases.
/// It simplifies imports in other layers by providing a single entry point
/// for domain-related functionalities.
library;

// Entities
export 'entities/author.dart';
export 'entities/feature.dart';
export 'entities/identifier.dart';
export 'entities/subscription.dart';

// Repository contracts
export 'repositories/auth_repository_interface.dart';
export 'repositories/subscription_repository_interface.dart';

// Use Cases
export 'usecases/get_subscription_by_slug.dart';
export 'usecases/get_subscriptions.dart';
export 'usecases/login_usecase.dart';
export 'usecases/logout_usecase.dart';
export 'usecases/usecase.dart';
