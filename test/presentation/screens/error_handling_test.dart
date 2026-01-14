import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/core/di/service_locator.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_state.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_event.dart'; // Importar SubscriptionEvent
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_state.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/not_found_screen.dart';

import 'package:empiricus_app_dev_beatriz_dadalto/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Importar os mocks que você já tem
import '../navigation_deeplink_test.dart'; // Contém MockAuthBloc e MockSubscriptionBloc

void main() {
  late MockAuthBloc authBloc;
  late MockSubscriptionBloc subscriptionBloc;

  setUpAll(() {
    // Registrar fallback values para eventos que podem ser passados para 'any'
    registerFallbackValue(const LoadSubscriptions());
    registerFallbackValue(const LoadSubscriptionDetail(slug: ''));
  });

  setUp(() {
    authBloc = MockAuthBloc();
    subscriptionBloc = MockSubscriptionBloc();

    // Desregistra e registra os mocks como SINGLETONS no GetIt
    if (getIt.isRegistered<AuthBloc>()) {
      getIt.unregister<AuthBloc>();
    }
    if (getIt.isRegistered<SubscriptionBloc>()) {
      getIt.unregister<SubscriptionBloc>();
    }
    getIt.registerSingleton<AuthBloc>(authBloc);
    getIt.registerSingleton<SubscriptionBloc>(subscriptionBloc);

    // Mocka o estado e stream do AuthBloc (autenticado por padrão para os testes de erro de subscrição)
    when(() => authBloc.state).thenReturn(const AuthSuccess(userEmail: 'test@emp.com'));
    whenListen(
      authBloc,
      Stream.value(const AuthSuccess(userEmail: 'test@emp.com')),
      initialState: const AuthSuccess(userEmail: 'test@emp.com'),
    );

    // Mocka o close() dos BLoCs
    when(() => authBloc.close()).thenAnswer((_) async {});
    when(() => subscriptionBloc.close()).thenAnswer((_) async {});

    // Ajusta o tamanho da janela do teste para Flutter 3.9+
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = const Size(1200, 2000);
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  });

  tearDown(() {
    // Limpa o tamanho da janela do teste
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.resetPhysicalSize();
    binding.platformDispatcher.views.first.resetDevicePixelRatio();
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

  group('Error Handling Tests - Visual Rendering', () {

    testWidgets('should display NotFoundScreen when subscription detail fails to load', (tester) async {
      addTearDown(() async {
        await authBloc.close();
        await subscriptionBloc.close();
      });

      // Configura o SubscriptionBloc para emitir SubscriptionError no detalhe
      whenListen(
        subscriptionBloc,
        Stream.fromIterable([
          const SubscriptionInitial(), // Estado inicial
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
      await tester.pumpAndSettle(const Duration(seconds: 3)); // Aguarda splash e redirecionamento

      // Navega para o detalhe de uma assinatura
      router.go('/subscriptions/assinatura-inexistente');
      await tester.pumpAndSettle();

      // Verifica se o NotFoundScreen foi renderizado
      expect(find.byType(NotFoundScreen), findsOneWidget);

      // Verifica se a mensagem de erro está visível
      expect(find.text('Assinatura não encontrada'), findsOneWidget);

      // Verifica se o ícone de erro está presente
      expect(find.byIcon(Icons.search_off), findsOneWidget);

      // Verifica se o título "Erro de Navegação" está visível
      expect(find.text('Erro de Navegação'), findsOneWidget);

      // Verifica que o detalhe da assinatura NÃO está visível
      expect(find.text('Detalhes'), findsNothing);
    });

  });
}
