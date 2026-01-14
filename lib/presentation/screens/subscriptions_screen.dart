import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/login/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/service_locator.dart';
import '../../routes/app_router.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/subscription/subscription_bloc.dart';
import '../bloc/subscription/subscription_event.dart';
import '../bloc/subscription/subscription_state.dart';
import '../widgets/error_display_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/subscription_list_view.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SubscriptionBloc>()..add(const LoadSubscriptions()),
      child: const _SubscriptionsView(),
    );
  }
}

class _SubscriptionsView extends StatelessWidget {
  const _SubscriptionsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthInitial) {
          context.go(AppRouter.login);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Assinaturas'),
          centerTitle: true,
          actions: const [LogoutButton(iconOnly: false), SizedBox(width: 8)],
        ),
        body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            return switch (state) {
              SubscriptionInitial() => const LoadingWidget(
                message: 'Iniciando...',
              ),
              SubscriptionLoading() => const LoadingWidget(
                message: 'Carregando assinaturas...',
              ),
              SubscriptionLoaded(:final subscriptions) => SubscriptionListView(
                subscriptions: subscriptions,
              ),
              SubscriptionDetailLoaded() => const LoadingWidget(),
              SubscriptionError(:final message) => ErrorDisplayWidget(
                message: message,
                onRetry: () {
                  context.read<SubscriptionBloc>().add(
                    const LoadSubscriptions(),
                  );
                },
              ),
            };
          },
        ),
      ),
    );
  }
}
