import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/subscription.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/feature_tile.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/subscription_detail/subscription_detail_authors_section.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/subscription_detail/subscription_detail_section_title.dart';
import 'package:empiricus_app_dev_beatriz_dadalto/presentation/widgets/subscription_detail/subscription_detail_sliver_app_bar.dart';
import 'package:flutter/material.dart';

class SubscriptionDetailContent extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionDetailContent({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SubscriptionDetailSliverAppBar(subscription: subscription),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),
              Text(
                subscription.shortDescription,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(subscription.description, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),

              if (subscription.authors.isNotEmpty) ...[
                const SubscriptionDetailSectionTitle(
                  title: 'Autores',
                  icon: Icons.people_outline,
                ),
                const SizedBox(height: 12),
                SubscriptionDetailAuthorsSection(authors: subscription.authors),
                const SizedBox(height: 24),
              ],

              if (subscription.features.isNotEmpty) ...[
                const SubscriptionDetailSectionTitle(
                  title: 'O que você recebe',
                  icon: Icons.start_outlined,
                ),
                const SizedBox(height: 12),
                ...subscription.features.map(
                  (feature) => FeatureTile(feature: feature),
                ),
              ],

              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }
}
