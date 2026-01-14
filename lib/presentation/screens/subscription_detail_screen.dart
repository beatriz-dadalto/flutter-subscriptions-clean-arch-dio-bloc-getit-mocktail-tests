import 'package:empiricus_app_dev_beatriz_dadalto/core/di/service_locator.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_event.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_state.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/screens/not_found_screen.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/loading_widget.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/subscription_detail/subscription_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SubscriptionDetailScreen extends StatelessWidget {
  final String slug;

  const SubscriptionDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<SubscriptionBloc>()..add(LoadSubscriptionDetail(slug: slug)),
      child: _DetailView(),
    );
  }
}

class _DetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        return switch (state) {
          SubscriptionInitial() || SubscriptionLoading() => const Scaffold(
            body: LoadingWidget(message: 'Carregando detalhes...'),
          ),

          SubscriptionLoaded() => const Scaffold(
            body: LoadingWidget(message: 'Estado inesperado'),
          ),

          SubscriptionDetailLoaded(:final subscription) => Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go('/subscriptions');
                  }
                },
              ),
              title: const Text('Detalhes'),
              centerTitle: true,
            ),
            body: SubscriptionDetailContent(subscription: subscription),
          ),

          SubscriptionError(:final message) => NotFoundScreen(
            message: message,
            icon: Icons.search_off,
            iconColor: Theme.of(context).colorScheme.error,
            buttonText: 'Voltar para a lista',
            routeToGo: '/subscriptions',
          ),
        };
      },
    );
  }
}
