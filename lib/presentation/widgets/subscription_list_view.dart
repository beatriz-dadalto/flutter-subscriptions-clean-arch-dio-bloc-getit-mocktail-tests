import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/subscription.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_bloc.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/bloc/subscription/subscription_event.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/subscription_card/subscription_card.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SubscriptionListView extends StatelessWidget {
  final List<Subscription> subscriptions;

  const SubscriptionListView({super.key, required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return const Center(child: Text('Nenhuma assinatura encontrada'));
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<SubscriptionBloc>().add(const RefreshSubscriptions());
        // disappear smoothly
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: subscriptions.length,
        itemBuilder: (BuildContext context, int index) {
          final subscription = subscriptions[index];
          return SubscriptionCard(
            subscription: subscription,
            onTap: () =>
                context.push('${AppRouter.subscriptions}/${subscription.slug}'),
          );
        },
      ),
    );
  }
}
