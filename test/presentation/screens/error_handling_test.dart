import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/core/di/service_locator.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_state.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_event.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_state.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/not_found_screen.dart';

import 'package:empiricus_app_dev_beatriz_dadalto/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../navigation_deeplink_test.dart';

void main() {
  late MockAuthBloc authBloc;
  late MockSubscriptionBloc subscriptionBloc;

  setUpAll(() {
    registerFallbackValue(const LoadSubscriptions());
    registerFallbackValue(const LoadSubscriptionDetail(slug: ''));
  });

  setUp(() {
    authBloc = MockAuthBloc();
    subscriptionBloc = MockSubscriptionBloc();

    if (getIt.isRegistered<AuthBloc>()) {
      getIt.unregister<AuthBloc>();
    }
    if (getIt.isRegistered<SubscriptionBloc>()) {
      getIt.unregister<SubscriptionBloc>();
    }
    getIt.registerSingleton<AuthBloc>(authBloc);
    getIt.registerSingleton<SubscriptionBloc>(subscriptionBloc);

    when(
      () => authBloc.state,
    ).thenReturn(const AuthSuccess(userEmail: 'test@emp.com'));
    whenListen(
      authBloc,
      Stream.value(const AuthSuccess(userEmail: 'test@emp.com')),
      initialState: const AuthSuccess(userEmail: 'test@emp.com'),
    );

    when(() => authBloc.close()).thenAnswer((_) async {});
    when(() => subscriptionBloc.close()).thenAnswer((_) async {});

    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = const Size(
      1200,
      2000,
    );
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  });

  tearDown(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.resetPhysicalSize();
    binding.platformDispatcher.views.first.resetDevicePixelRatio();
  });

  Widget buildTestApp(GoRouter router) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<SubscriptionBloc>.value(value: subscriptionBloc),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('Error Handling Tests - Visual Rendering', () {
    testWidgets(
      'should display NotFoundScreen when subscription detail fails to load',
      (tester) async {
        addTearDown(() async {
          await authBloc.close();
          await subscriptionBloc.close();
        });

        whenListen(
          subscriptionBloc,
          Stream.fromIterable([
            const SubscriptionInitial(),
            const SubscriptionLoading(),
            const SubscriptionError(message: 'Assinatura não encontrada'),
          ]),
          initialState: const SubscriptionInitial(),
        );

        final router = AppRouter.createRouter(
          authBloc: authBloc,
          subscriptionBloc: subscriptionBloc,
        );

        await tester.pumpWidget(buildTestApp(router));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        router.go('/subscriptions/assinatura-inexistente');
        await tester.pumpAndSettle();

        expect(find.byType(NotFoundScreen), findsOneWidget);

        expect(find.text('Assinatura não encontrada'), findsOneWidget);

        expect(find.byIcon(Icons.search_off), findsOneWidget);

        expect(find.text('Erro de Navegação'), findsOneWidget);

        expect(find.text('Detalhes'), findsNothing);
      },
    );
  });
}
