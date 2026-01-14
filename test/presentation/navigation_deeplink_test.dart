import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/core/di/service_locator.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/subscription.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_state.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_state.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes para os BLoCs
class MockAuthBloc extends Mock implements AuthBloc {}

class MockSubscriptionBloc extends Mock implements SubscriptionBloc {}

void main() {
  // Declaração das variáveis que serão inicializadas no setUp
  late MockAuthBloc authBloc;
  late MockSubscriptionBloc subscriptionBloc;
  late Subscription fakeSubscription;

  // Função auxiliar para configurar o GetIt, garantindo que os BLoCs sejam registrados corretamente
  // ignore: no_leading_underscores_for_local_identifiers
  void _setupGetIt() {
    if (getIt.isRegistered<AuthBloc>()) {
      getIt.unregister<AuthBloc>();
    }
    if (getIt.isRegistered<SubscriptionBloc>()) {
      getIt.unregister<SubscriptionBloc>();
    }
    getIt.registerSingleton<AuthBloc>(authBloc);
    getIt.registerSingleton<SubscriptionBloc>(subscriptionBloc);
  }

  // Configuração inicial para cada teste
  setUp(() {
    authBloc = MockAuthBloc();
    subscriptionBloc = MockSubscriptionBloc();
    fakeSubscription = Subscription.fake(
      slug: 'vacas-leiteiras',
      name: 'Nome da Assinatura',
    );

    // Configura o GetIt para cada teste
    _setupGetIt();

    // Define o estado inicial padrão para os BLoCs mockados
    when(() => authBloc.state).thenReturn(const AuthSuccess(userEmail: 'test@emp.com'));
    whenListen(authBloc, Stream.value(const AuthSuccess(userEmail: 'test@emp.com')),
        initialState: const AuthSuccess(userEmail: 'test@emp.com')); // Garante initialState explícito

    when(() => subscriptionBloc.state).thenReturn(const SubscriptionInitial());
    whenListen(subscriptionBloc, Stream.value(const SubscriptionInitial()),
        initialState: const SubscriptionInitial()); // Garante initialState explícito

    // Mocka o fechamento dos BLoCs para evitar erros de dispose
    when(() => subscriptionBloc.close()).thenAnswer((_) async {});
    when(() => authBloc.close()).thenAnswer((_) async {});

    // Ajusta o tamanho da janela do teste para Flutter 3.9+
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = const Size(1200, 2000);
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  });

  // Limpeza após cada teste
  tearDown(() {
    // Limpa o tamanho da janela do teste (Flutter 3.9+)
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.resetPhysicalSize();
    binding.platformDispatcher.views.first.resetDevicePixelRatio();

    // Garante que os BLoCs sejam fechados após cada teste, liberando recursos
    // Isso é importante para evitar vazamentos de memória e garantir isolamento entre os testes.
    authBloc.close();
    subscriptionBloc.close();
  });

  // Função auxiliar para construir o widget a ser testado
  Widget buildTestApp(GoRouter router) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<SubscriptionBloc>.value(value: subscriptionBloc),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('Deeplink Navigation Tests', () {
    testWidgets('should navigate to subscription list when deeplinked to /subscriptions', (tester) async {
      // Configura o stream do SubscriptionBloc para simular o carregamento e sucesso
      whenListen(
        subscriptionBloc,
        Stream.fromIterable([
          const SubscriptionLoading(),
          SubscriptionLoaded([fakeSubscription]),
        ]),
        initialState: const SubscriptionInitial(),
      );

      // Cria o router com os BLoCs mockados
      final router = AppRouter.createRouter(
        authBloc: authBloc,
        subscriptionBloc: subscriptionBloc,
      );

      // Navega para o deeplink da lista de assinaturas
      router.go(AppRouter.subscriptions);

      // Renderiza o widget e espera a conclusão das animações
      await tester.pumpWidget(buildTestApp(router));
      await tester.pumpAndSettle();

      // Verifica se os widgets esperados estão presentes na tela
      expect(find.text('Assinaturas'), findsOneWidget);
      expect(find.text('Nome da Assinatura'), findsOneWidget);
    });

    testWidgets('should navigate to subscription detail when deeplinked to /subscriptions/:slug', (tester) async {
      // Configura o stream do SubscriptionBloc para simular o carregamento e sucesso do detalhe
      whenListen(
        subscriptionBloc,
        Stream.fromIterable([
          const SubscriptionLoading(),
          SubscriptionDetailLoaded(fakeSubscription),
        ]),
        initialState: const SubscriptionInitial(),
      );

      // Cria o router com os BLoCs mockados
      final router = AppRouter.createRouter(
        authBloc: authBloc,
        subscriptionBloc: subscriptionBloc,
      );

      // Navega para o deeplink de detalhe de assinatura
      router.go('/subscriptions/vacas-leiteiras');

      // Renderiza o widget e espera a conclusão das animações
      await tester.pumpWidget(buildTestApp(router));
      await tester.pumpAndSettle();

      // Verifica se os widgets esperados estão presentes na tela
      expect(find.text('Detalhes'), findsOneWidget);
      expect(find.text('Nome da Assinatura'), findsOneWidget);
    });
  });
}
