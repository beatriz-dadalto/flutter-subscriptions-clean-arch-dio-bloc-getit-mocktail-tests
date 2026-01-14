import 'package:empiricus_app_dev_beatriz_dadalto/domain/entities/subscription.dart';
import 'package:flutter/material.dart';

class SubscriptionDetailSliverAppBar extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionDetailSliverAppBar({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: theme.colorScheme.surface,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final isCollapsed = constraints.maxHeight <= kToolbarHeight + 24;
          return FlexibleSpaceBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                subscription.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCollapsed
                      ? theme
                            .colorScheme
                            .onSurface // preto
                      : Colors.white, // branco sobre imagem
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  subscription.imageLarge,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: theme.colorScheme.primaryContainer,
                    child: const Icon(Icons.image_not_supported, size: 64),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
