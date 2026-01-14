import 'package:flutter/material.dart';

class AppSloganAnimated extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const AppSloganAnimated({super.key, required this.fadeAnimation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        children: [
          Text(
            'Empiricus',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inteligência financeira ao seu alcance',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
