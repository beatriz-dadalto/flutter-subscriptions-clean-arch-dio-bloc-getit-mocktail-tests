import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/core/di/service_locator.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_event.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_state.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_state.dart';
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
    // Registra os fallbacks para any<T>() que são usados em verify
    registerFallbackValue(const LoginRequested(email: '', password: ''));
    registerFallbackValue(const AuthCheckRequested());
    registerFallbackValue(const LogoutRequested());
  });

  setUp(() {
    authBloc = MockAuthBloc();
    subscriptionBloc = MockSubscriptionBloc();

    // Desregistra e registra os mocks como SINGLETONS no GetIt.
    // Isso garante que TODAS as chamadas a getIt<Bloc>() retornem a MESMA instância.
    if (getIt.isRegistered<AuthBloc>()) {
      getIt.unregister<AuthBloc>();
    }
    if (getIt.isRegistered<SubscriptionBloc>()) {
      getIt.unregister<SubscriptionBloc>();
    }
    getIt.registerSingleton<AuthBloc>(authBloc);
    getIt.registerSingleton<SubscriptionBloc>(subscriptionBloc);

    // Mocka o close() dos BLoCs para evitar erros de dispose
    // O MockBloc já implementa close(), então apenas garantimos que não haja erro.
    when(() => authBloc.close()).thenAnswer((_) async {});
    when(() => subscriptionBloc.close()).thenAnswer((_) async {});

    // Ajusta o tamanho da janela do teste para Flutter 3.9+
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = const Size(
      1200,
      2000,
    );
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  });

  tearDown(() {
    // Limpa o tamanho da janela do teste
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.resetPhysicalSize();
    binding.platformDispatcher.views.first.resetDevicePixelRatio();

    // Garante que os BLoCs sejam fechados após cada teste
    authBloc.close();
    subscriptionBloc.close();
  });

  /// Widget auxiliar para construir o app de teste
  Widget buildTestApp(GoRouter router) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<SubscriptionBloc>.value(value: subscriptionBloc),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('Login Tests', () {

    testWidgets(
      'should block navigation to subscriptions without authentication',
      (tester) async {
        when(() => authBloc.add(any())).thenAnswer((_) {});
        whenListen(
          authBloc,
          Stream.value(const AuthInitial()),
          initialState: const AuthInitial(),
        );
        when(
          () => subscriptionBloc.state,
        ).thenReturn(const SubscriptionInitial());
        whenListen(
          subscriptionBloc,
          Stream.value(const SubscriptionInitial()),
          initialState: const SubscriptionInitial(),
        );
        final router = AppRouter.createRouter(
          authBloc: authBloc,
          subscriptionBloc: subscriptionBloc,
        );
        await tester.pumpWidget(buildTestApp(router));
        authBloc.add(const AuthCheckRequested());
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle(const Duration(seconds: 2));
        router.go(AppRouter.subscriptions);
        await tester.pump(const Duration(seconds: 2));
        expect(find.text('Bem-vindo!'), findsOneWidget);
        expect(find.text('Entrar'), findsOneWidget);
        expect(find.text('Assinaturas'), findsNothing);
      },
    );

    testWidgets('should redirect to subscriptions when already authenticated', (
      tester,
    ) async {
      when(() => authBloc.add(any())).thenAnswer((_) {});
      whenListen(
        authBloc,
        Stream.value(const AuthSuccess(userEmail: 'admin@email.com')),
        initialState: const AuthSuccess(userEmail: 'admin@email.com'),
      );
      when(
        () => subscriptionBloc.state,
      ).thenReturn(const SubscriptionInitial());
      whenListen(
        subscriptionBloc,
        Stream.value(const SubscriptionInitial()),
        initialState: const SubscriptionInitial(),
      );
      final router = AppRouter.createRouter(
        authBloc: authBloc,
        subscriptionBloc: subscriptionBloc,
      );
      await tester.pumpWidget(buildTestApp(router));
      authBloc.add(const AuthCheckRequested());
      await tester.pump(const Duration(seconds: 2));
      router.go(AppRouter.login);
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Assinaturas'), findsOneWidget);
      // Não verifica mais 'Bem-vindo!' pois navegação já ocorreu
    });
  });
}
