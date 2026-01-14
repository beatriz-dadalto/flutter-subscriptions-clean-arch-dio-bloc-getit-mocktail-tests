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

class MockAuthBloc extends Mock implements AuthBloc {}

class MockSubscriptionBloc extends Mock implements SubscriptionBloc {}

void main() {
  late MockAuthBloc authBloc;
  late MockSubscriptionBloc subscriptionBloc;
  late Subscription fakeSubscription;
  late List<Subscription> fakeSubscriptions;

  setUpAll(() {
    registerFallbackValue(const LoadSubscriptions());
    registerFallbackValue(const LoadSubscriptionDetail(slug: 'any'));
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

    when(() => authBloc.close()).thenAnswer((_) async {});
    when(() => subscriptionBloc.close()).thenAnswer((_) async {});

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

    authBloc.close();
    subscriptionBloc.close();
  });

  Widget buildTestApp(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<SubscriptionBloc>.value(value: subscriptionBloc),
      ],
      child: MaterialApp(
        home: child,

        builder: (context, child) {
          return ScaffoldMessenger(child: child!);
        },
      ),
    );
  }

  group('Widget Rendering Tests', () {
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
        when(
          () => authBloc.state,
        ).thenReturn(const AuthSuccess(userEmail: 'test@emp.com'));
        whenListen(
          authBloc,
          Stream.value(const AuthSuccess(userEmail: 'test@emp.com')),
        );

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
        await tester.pumpAndSettle();

        expect(find.text('Assinaturas'), findsOneWidget);

        expect(
          find.byType(SubscriptionCard),
          findsNWidgets(fakeSubscriptions.length),
        );
        expect(find.text(fakeSubscription.name), findsOneWidget);
        expect(find.text(fakeSubscriptions[1].name), findsOneWidget);

        verify(() => subscriptionBloc.add(const LoadSubscriptions())).called(1);
      });

      testWidgets(
        'should display "Nenhuma assinatura encontrada" when list is empty',
        (tester) async {
          when(
            () => authBloc.state,
          ).thenReturn(const AuthSuccess(userEmail: 'test@emp.com'));
          whenListen(
            authBloc,
            Stream.value(const AuthSuccess(userEmail: 'test@emp.com')),
          );

          when(
            () => subscriptionBloc.state,
          ).thenReturn(const SubscriptionInitial());
          whenListen(
            subscriptionBloc,
            Stream.fromIterable([
              const SubscriptionLoading(),
              const SubscriptionLoaded([]),
            ]),
            initialState: const SubscriptionInitial(),
          );

          await tester.pumpWidget(buildTestApp(const SubscriptionsScreen()));
          await tester.pumpAndSettle();
          expect(find.text('Nenhuma assinatura encontrada'), findsOneWidget);
          expect(find.byType(SubscriptionCard), findsNothing);
        },
      );
    });

    group('SubscriptionDetailScreen', () {
      testWidgets(
        'should display NotFoundScreen when subscription detail fails to load',
        (tester) async {
          when(
            () => authBloc.state,
          ).thenReturn(const AuthSuccess(userEmail: 'test@emp.com'));
          whenListen(
            authBloc,
            Stream.value(const AuthSuccess(userEmail: 'test@emp.com')),
          );

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

          expect(find.byType(NotFoundScreen), findsOneWidget);

          expect(find.text('Assinatura não encontrada'), findsOneWidget);
          expect(find.text('Erro de Navegação'), findsOneWidget);
          expect(find.byIcon(Icons.search_off), findsOneWidget);
          expect(
            find.widgetWithText(ElevatedButton, 'Voltar para a lista'),
            findsOneWidget,
          );
        },
      );
    });

    group('LoginScreen', () {
      testWidgets('should display LoginHeader and LoginForm', (tester) async {
        when(() => authBloc.state).thenReturn(const AuthInitial());
        whenListen(authBloc, Stream.value(const AuthInitial()));

        await tester.pumpWidget(buildTestApp(const LoginScreen()));
        await tester.pumpAndSettle();

        expect(find.byType(LoginHeader), findsOneWidget);
        expect(find.text('Bem-vindo!'), findsOneWidget);

        expect(find.byType(LoginForm), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.text('Entrar'), findsOneWidget);
      });

      testWidgets(
        'should display SnackBar and error message when login fails',
        (tester) async {
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

          await tester.enterText(
            find.byType(TextFormField).first,
            'wrong@email.com',
          );
          await tester.enterText(find.byType(TextFormField).last, 'wrong');
          await tester.tap(find.text('Entrar'));
          await tester.pump(); 

          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(find.byType(SnackBar), findsOneWidget);
          expect(
            find.text('Credenciais inválidas. Verifique email e senha.'),
            findsWidgets,
          );

          expect(
            find.text('Credenciais inválidas. Verifique email e senha.'),
            findsWidgets,
          );
        },
      );
    });
  });
}
