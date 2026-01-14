import 'dart:async';

import 'package:empiricus_app_dev_beatriz_dadalto/core/di/service_locator.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_state.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/login_screen.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/not_found_screen.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/splash_screen.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/subscription_detail_screen.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/subscriptions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Class that defines the application's routes
abstract final class AppRouter {
  AppRouter._();

  // Route names for easier navigation and to avoid magic strings.
  static const String splash = '/';
  static const String login = '/login';
  static const String subscriptions = '/subscriptions';
  static const String subscriptionDetail = '/subscriptions/:slug';
  static const String notFound = '/404'; // Rota explícita para NotFoundScreen

  /// Creates and returns a new [GoRouter] instance.
  ///
  /// This method is the only way to obtain a [GoRouter] instance
  /// and is designed to be called after the `service_locator` (GetIt)
  /// has registered all its dependencies.
  ///
  /// Optionally accepts `authBloc` and `subscriptionBloc` to facilitate
  /// injection of mocks in tests, maintaining flexibility.
  static GoRouter createRouter({
    AuthBloc? authBloc,
    SubscriptionBloc? subscriptionBloc,
  }) {
    // If BLoCs are not provided (in production), they are obtained from GetIt.
    // In tests, they will be provided as mocks.
    // ignore: no_leading_underscores_for_local_identifiers
    final _authBloc = authBloc ?? getIt<AuthBloc>();
    // ignore: no_leading_underscores_for_local_identifiers
    final _subscriptionBloc = subscriptionBloc ?? getIt<SubscriptionBloc>();

    return GoRouter(
      initialLocation: AppRouter.splash,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: subscriptions,
          name: 'subscriptions',
          builder: (context, state) => BlocProvider.value(
            value: _subscriptionBloc,
            child: const SubscriptionsScreen(),
          ),
        ),
        GoRoute(
          path: subscriptionDetail,
          name: 'subscription-detail',
          builder: (context, state) {
            final slug = state.pathParameters['slug'];
            return BlocProvider.value(
              value: _subscriptionBloc,
              child: SubscriptionDetailScreen(slug: slug ?? ''),
            );
          },
        ),
        GoRoute(
          path: notFound,
          builder: (context, state) => const NotFoundScreen(
            message: 'Assinatura não encontrada',
          ),
        ),
      ],

      redirect: (context, state) {
        final bool isAuthenticated = _authBloc.state is AuthSuccess;
        final bool isLoggingIn = state.matchedLocation == login;
        final bool isGoingToSplash = state.matchedLocation == splash;

        if (isGoingToSplash && _authBloc.state is AuthInitial) {
          return null;
        }

        if (!isAuthenticated && !isLoggingIn && !isGoingToSplash) {
          return login;
        }

        if (isAuthenticated && (isLoggingIn || isGoingToSplash)) {
          return subscriptions;
        }

        return null;
      },
      // Adds a refreshListenable so that the redirect is re-evaluated when the authentication state changes.
      refreshListenable: GoRouterRefreshStream(_authBloc.stream),

      errorBuilder: (context, state) => NotFoundScreen(
        message: 'Assinatura não encontrada',
        icon: Icons.sentiment_dissatisfied,
        iconColor: Theme.of(context).colorScheme.error,
        buttonText: 'Voltar ao início',
        routeToGo: AppRouter.subscriptions,
      ),
    );
  }
}

/// Helper class to convert a Stream into a Listenable.
/// Used so that GoRouter can react to changes in the BLoC state.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
