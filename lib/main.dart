import 'package:empiricus_app_dev_beatriz_dadalto/core/theme/app_theme.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/auth/auth_event.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/di/service_locator.dart';
import 'routes/app_router.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  getIt<AuthBloc>().add(const AuthCheckRequested());
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const EmpricusApp());
}
class EmpricusApp extends StatelessWidget {
  const EmpricusApp({super.key});
  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = getIt<AuthBloc>();
    final SubscriptionBloc subscriptionBloc = getIt<SubscriptionBloc>();
    final GoRouter router = AppRouter.createRouter(
      authBloc: authBloc,
      subscriptionBloc: subscriptionBloc,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<SubscriptionBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Empiricus',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: AppTheme.light,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
