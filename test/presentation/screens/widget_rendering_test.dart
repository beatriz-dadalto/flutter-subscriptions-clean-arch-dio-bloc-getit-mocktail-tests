import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/core/di/service_locator.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/author.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/feature.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/subscription.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_state.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_event.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_state.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/login_screen.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/not_found_screen.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/subscription_detail_screen.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/subscriptions_screen.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/loading_widget.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/login/login_form.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/login/login_header.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/subscription_card/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks para os BLoCs
class MockAuthBloc extends Mock implements AuthBloc {}

class MockSubscriptionBloc extends Mock implements SubscriptionBloc {}

void main() {
  late MockAuthBloc authBloc;
  late MockSubscriptionBloc subscriptionBloc;
  late Subscription fakeSubscription;
  late List<Subscription> fakeSubscriptions;

  setUpAll(() {
    // Registra os fallbacks para any<T>() que são usados em verify
    registerFallbackValue(const LoadSubscriptions());
    registerFallbackValue(const LoadSubscriptionDetail(slug: 'any'));
  });

  setUp(() {
    authBloc = MockAuthBloc();
    subscriptionBloc = MockSubscriptionBloc();

    // Desregistra e registra os mocks como SINGLETONS no GetIt.
    if (getIt.isRegistered<AuthBloc>()) {
      getIt.unregister<AuthBloc>();
    }
    if (getIt.isRegistered<SubscriptionBloc>()) {
      getIt.unregister<SubscriptionBloc>();
    }
    getIt.registerSingleton<AuthBloc>(authBloc);
    getIt.registerSingleton<SubscriptionBloc>(subscriptionBloc);

    // Mocka o close() dos BLoCs para evitar erros de dispose
    when(() => authBloc.close()).thenAnswer((_) async {});
    when(() => subscriptionBloc.close()).thenAnswer((_) async {});

    // Dados de teste
    fakeSubscription = Subscription.fake(
      slug: 'vacas-leiteiras',
      name: 'Vacas Leiteiras: Oportunidades no Agronegócio',
      shortDescription: 'Um guia completo para investir em gado leiteiro.',
      description:
          'Esta assinatura oferece análises aprofundadas sobre o mercado de laticínios, '
          'melhores práticas de manejo e projeções de rentabilidade para o setor. '
          'Ideal para investidores que buscam diversificação e retornos consistentes no agronegócio.',
      authors: [
        Author.fake(name: 'Dr. Agro', bio: 'Especialista em pecuária'),
        Author.fake(name: 'Ana Lítica', bio: 'Analista de mercado'),
      ],
      features: [
        Feature.fake(
          title: 'Relatórios semanais',
          description: 'Análises de mercado',
        ),
        Feature.fake(
          title: 'Acesso a webinars',
          description: 'Palestras com especialistas',
        ),
      ],
      imageLarge: 'https://example.com/vacas-leiteiras-large.jpg',
      imageSmall: 'https://example.com/vacas-leiteiras-small.jpg',
    );
    fakeSubscriptions = [
      fakeSubscription,
      Subscription.fake(slug: 'cafe-premium', name: 'Café Premium'),
    ];

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
  /// Este builder é mais simples, focado em montar um widget específico
  /// sem a complexidade do GoRouter para navegação inicial.
  Widget buildTestApp(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<SubscriptionBloc>.value(value: subscriptionBloc),
      ],
      child: MaterialApp(
        home: child,
        // Adiciona um ScaffoldMessenger para que SnackBar possa ser exibido
        builder: (context, child) {
          return ScaffoldMessenger(child: child!);
        },
      ),
    );
  }

  group('Widget Rendering Tests', () {
    // =======================================================================
    // 1. SubscriptionsScreen (Lista de Assinaturas)
    // =======================================================================
    group('SubscriptionsScreen', () {



      testWidgets('should display LoadingWidget while loading subscriptions', (
        tester,
      ) async {
        when(
          () => authBloc.state,
        ).thenReturn(const AuthSuccess(userEmail: 'test@emp.com'));
        whenListen(
          authBloc,
          Stream.value(const AuthSuccess(userEmail: 'test@emp.com')),
        );
        when(
          () => subscriptionBloc.state,
        ).thenReturn(const SubscriptionLoading());
        whenListen(
          subscriptionBloc,
          Stream.value(const SubscriptionLoading()),
          initialState: const SubscriptionInitial(),
        );
        await tester.pumpWidget(buildTestApp(const SubscriptionsScreen()));
        await tester.pump();
        expect(find.byType(LoadingWidget), findsOneWidget);
        expect(find.text('Carregando assinaturas...'), findsOneWidget);
      });

      testWidgets('should display a list of subscriptions when loaded', (
        tester,
      ) async {
        // Configura o AuthBloc para estar autenticado
        when(
          () => authBloc.state,
        ).thenReturn(const AuthSuccess(userEmail: 'test@emp.com'));
        whenListen(
          authBloc,
          Stream.value(const AuthSuccess(userEmail: 'test@emp.com')),
        );

        // Configura o SubscriptionBloc para emitir SubscriptionLoaded
        when(
          () => subscriptionBloc.state,
        ).thenReturn(const SubscriptionInitial());
        whenListen(
          subscriptionBloc,
          Stream.fromIterable([
            const SubscriptionLoading(),
            SubscriptionLoaded(fakeSubscriptions),
          ]),
          initialState: const SubscriptionInitial(),
        );

        await tester.pumpWidget(buildTestApp(const SubscriptionsScreen()));
        await tester
            .pumpAndSettle(); // Aguarda o BLoC carregar e a UI estabilizar

        // Verifica se a AppBar com o título "Assinaturas" está presente
        expect(find.text('Assinaturas'), findsOneWidget);

        // Verifica se os cards das assinaturas foram renderizados
        expect(
          find.byType(SubscriptionCard),
          findsNWidgets(fakeSubscriptions.length),
        );
        expect(find.text(fakeSubscription.name), findsOneWidget);
        expect(find.text(fakeSubscriptions[1].name), findsOneWidget);

        // Verifica se o evento LoadSubscriptions foi adicionado
        verify(() => subscriptionBloc.add(const LoadSubscriptions())).called(1);
      });

      testWidgets(
        'should display "Nenhuma assinatura encontrada" when list is empty',
        (tester) async {
          // Configura o AuthBloc para estar autenticado
          when(
            () => authBloc.state,
          ).thenReturn(const AuthSuccess(userEmail: 'test@emp.com'));
          whenListen(
            authBloc,
            Stream.value(const AuthSuccess(userEmail: 'test@emp.com')),
          );

          // Configura o SubscriptionBloc para emitir SubscriptionLoaded com lista vazia
          when(
            () => subscriptionBloc.state,
          ).thenReturn(const SubscriptionInitial());
          whenListen(
            subscriptionBloc,
            Stream.fromIterable([
              const SubscriptionLoading(),
              const SubscriptionLoaded([]), // Lista vazia
            ]),
            initialState: const SubscriptionInitial(),
          );

          await tester.pumpWidget(buildTestApp(const SubscriptionsScreen()));
          await tester.pumpAndSettle();

          // Verifica se a mensagem de lista vazia é exibida
          expect(find.text('Nenhuma assinatura encontrada'), findsOneWidget);
          expect(
            find.byType(SubscriptionCard),
            findsNothing,
          ); // Nenhum card deve ser encontrado
        },
      );



    });

    // =======================================================================
    // 2. SubscriptionDetailScreen (Detalhe da Assinatura)
    // =======================================================================
    group('SubscriptionDetailScreen', () {


      testWidgets(
        'should display NotFoundScreen when subscription detail fails to load',
        (tester) async {
          // Configura o AuthBloc para estar autenticado
          when(
            () => authBloc.state,
          ).thenReturn(const AuthSuccess(userEmail: 'test@emp.com'));
          whenListen(
            authBloc,
            Stream.value(const AuthSuccess(userEmail: 'test@emp.com')),
          );

          // Configura o SubscriptionBloc para emitir SubscriptionError
          when(
            () => subscriptionBloc.state,
          ).thenReturn(const SubscriptionInitial());
          whenListen(
            subscriptionBloc,
            Stream.fromIterable([
              const SubscriptionLoading(),
              const SubscriptionError(message: 'Assinatura não encontrada'),
            ]),
            initialState: const SubscriptionInitial(),
          );

          await tester.pumpWidget(
            buildTestApp(
              const SubscriptionDetailScreen(slug: 'assinatura-inexistente'),
            ),
          );
          await tester.pumpAndSettle();

          // Verifica se o NotFoundScreen foi renderizado
          expect(find.byType(NotFoundScreen), findsOneWidget);

          // Verifica se a mensagem de erro está visível
          expect(find.text('Assinatura não encontrada'), findsOneWidget);
          expect(
            find.text('Erro de Navegação'),
            findsOneWidget,
          ); // Título da AppBar do NotFoundScreen
          expect(
            find.byIcon(Icons.search_off),
            findsOneWidget,
          ); // Ícone customizado para NotFoundScreen
          expect(
            find.widgetWithText(ElevatedButton, 'Voltar para a lista'),
            findsOneWidget,
          );
        },
      );
    });

    // =======================================================================
    // 3. LoginScreen (Tela de Login)
    // =======================================================================
    group('LoginScreen', () {
      testWidgets('should display LoginHeader and LoginForm', (tester) async {
        // Configura o AuthBloc para estar no estado inicial
        when(() => authBloc.state).thenReturn(const AuthInitial());
        whenListen(authBloc, Stream.value(const AuthInitial()));

        await tester.pumpWidget(buildTestApp(const LoginScreen()));
        await tester.pumpAndSettle();

        // Verifica se o LoginHeader está presente
        expect(find.byType(LoginHeader), findsOneWidget);
        expect(find.text('Bem-vindo!'), findsOneWidget);

        // Verifica se o LoginForm está presente
        expect(find.byType(LoginForm), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2)); // Email e Senha
        expect(find.text('Entrar'), findsOneWidget);
      });

      testWidgets('should display SnackBar and error message when login fails', (
        tester,
      ) async {
        // Configura o AuthBloc para emitir AuthFailure
        when(() => authBloc.state).thenReturn(const AuthInitial());
        whenListen(
          authBloc,
          Stream.fromIterable([
            const AuthInitial(),
            const AuthLoading(),
            const AuthFailure(
              message: 'Credenciais inválidas. Verifique email e senha.',
            ),
          ]),
          initialState: const AuthInitial(),
        );

        await tester.pumpWidget(buildTestApp(const LoginScreen()));
        await tester.pumpAndSettle();

        // Simula a entrada de texto e o tap no botão de login
        await tester.enterText(
          find.byType(TextFormField).first,
          'wrong@email.com',
        );
        await tester.enterText(find.byType(TextFormField).last, 'wrong');
        await tester.tap(find.text('Entrar'));
        await tester.pump(); // Processa o tap e o AuthLoading

        // Aguarda o SnackBar aparecer e a UI se estabilizar após o AuthFailure
        // Um pumpAndSettle sem duração pode ser suficiente se o SnackBar for rápido,
        // mas um pequeno delay pode ser necessário dependendo da animação.
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Verifica se o SnackBar foi renderizado
        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.text('Credenciais inválidas. Verifique email e senha.'),
          findsWidgets,
        ); // SnackBar e texto abaixo do form

        // Verifica se a mensagem de erro também aparece abaixo do formulário
        expect(
          find.text('Credenciais inválidas. Verifique email e senha.'),
          findsWidgets,
        );
      });
    });
  });
}
